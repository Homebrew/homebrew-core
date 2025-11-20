# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-7.1.2.tar.gz"
  sha256 "ce27b9a4767cf2ea496b51468bae512fa6a6eaf0891e49f8961dc694b4dc81ca"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e9317232e4d64a63fd18d1d57ff64bb72c86514cb91d47823e78996e317502d8"
    sha256 arm64_sequoia: "5d06c3f6f5c8fe73397da5f6976aa2c85143362ba3da9887ed2ad26e91355fea"
    sha256 arm64_sonoma:  "ae97183ee9cbae17551ac76ca2e8761ae2c55f82880b3e5b22bcf95dd08dcd8f"
    sha256 tahoe:         "fdd91a61b1e6294d834fc23e7ebabada863f8e1580e5e4dc4df52f681e44f34c"
    sha256 sequoia:       "42e620046194f67bc4c79e132cd13a2c028f48adb704a4ea73ef2ea0d6669294"
    sha256 sonoma:        "8bd7368319b0c07882655a590d8ce824da1e4c96c2aba737b824d49091412de3"
    sha256 arm64_linux:   "9693770c636081f6caa6e3886b5873d0cf80a6ac417d3190726c47bd79714a89"
    sha256 x86_64_linux:  "867cf560617edbc930596f467e5be84fd735eacfe4fd263a65d1af51ef83dfe3"
  end

  depends_on "python@3.14"

  def install
    python3 = "python3.14"
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

    # Install chg (see https://www.mercurial-scm.org/wiki/CHg)
    system "make", "-C", "contrib/chg", "install", "PREFIX=#{prefix}", "HGPATH=#{bin}/hg", "HG=#{bin}/hg"

    # Configure a nicer default pager
    (buildpath/"hgrc").write <<~EOS
      [pager]
      pager = less -FRX
    EOS

    (etc/"mercurial").install "hgrc"

    # Install man pages, which come pre-built in source releases
    man1.install "doc/hg.1"
    man5.install "doc/hgignore.5", "doc/hgrc.5"

    # Move the bash completion script
    bash_completion.install share/"bash-completion/completions/hg"
  end

  def post_install
    return unless (opt_bin/"hg").exist?
    return unless deps.all? { |d| d.build? || d.test? || d.to_formula.any_version_installed? }

    cacerts_configured = `#{opt_bin}/hg config web.cacerts`.strip
    return if cacerts_configured.empty?

    opoo <<~EOS
      Homebrew has detected that Mercurial is configured to use a certificate
      bundle file as its trust store for TLS connections instead of using the
      default OpenSSL store. If you have trouble connecting to remote
      repositories, consider unsetting the `web.cacerts` property. You can
      determine where the property is being set by running:
        hg config --debug web.cacerts
    EOS
  end

  test do
    touch "foobar"
    system bin/"hg", "init"
    system bin/"hg", "add", "foobar"
    system bin/"hg", "--config", "ui.username=brew", "commit", "-m", "initial commit"
    assert_equal "foobar\n", shell_output("#{bin}/hg locate")
    # Check for chg
    assert_match "initial commit", shell_output("#{bin}/chg log")
  end
end
