# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.7.3.tar.gz"
  sha256 "00196944ea92738809317dc7a8ed7cb21287ca0a00a85246e66170955dcd9031"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e3fad805f06988769ae9178e818ab2a9ef9c8ccedbd5f89c7383bcbf64ba829c"
    sha256 arm64_ventura:  "f0105793e8412b46760cf2538a3f991428632786db9c9e92d84837502b48d18a"
    sha256 arm64_monterey: "8a435f73dd1f45b57a721bb391776155d0ccee0a3134c2086845f520879a4917"
    sha256 sonoma:         "7d81c00cfb9bade68d92d476a0b72d2544f8117933baea06324dd87180d8516a"
    sha256 ventura:        "a87e0f527f50ebcbad816d3ed2811286d7baf6a63735d7cd2f3a88bed6fe80ee"
    sha256 monterey:       "7ee5172c238d6e7a965eb2e6cecb38befab9b0119a66303f08b91395c4077769"
    sha256 x86_64_linux:   "59ecaa63c0ff0a230427d4af458a9d22a7b7bb0192e0db6bf8d029b546c65bff"
  end

  depends_on "python@3.12"

  def install
    python3 = "python3.12"
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

  def caveats
    return unless (opt_bin/"hg").exist?
    return unless deps.all? { |d| d.build? || d.test? || d.to_formula.any_version_installed? }

    cacerts_configured = `#{opt_bin}/hg config web.cacerts`.strip
    return if cacerts_configured.empty?

    <<~EOS
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
