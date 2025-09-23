# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-7.1.1.tar.gz"
  sha256 "47cf66ba89c175536faf844c9b4cd962eb432afb516c073e51f436bf3f0bc148"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "5fe2ad981097944a498924e030e01fb5b8b6d97d3d3b67758e2fd92c74690702"
    sha256 arm64_sequoia: "bc8bececd85b3c7b8c337fc53a273d8a4887906cc6a6656fb371e10ed291f3b0"
    sha256 arm64_sonoma:  "e5e1227d205f33b481d8023556bb55eb39315fe0351d68a376a14b8c6eab0bf4"
    sha256 sonoma:        "86ca0d3d30328ed4da8fb7d37390ea43bc9c2fd4337f9dac8761dbbb7be0465f"
    sha256 arm64_linux:   "27bf5c9dcb182aebe61e746815456d5320a1f85f41ffb743e41c5979b925955c"
    sha256 x86_64_linux:  "46654ab14b457ed78df2d327fd37b6dd139b630ceab624bfb6ffc914543eb324"
  end

  depends_on "python@3.13"

  def install
    python3 = "python3.13"
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
