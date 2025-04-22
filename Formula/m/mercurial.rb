# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-7.0.1.tar.gz"
  sha256 "0f4cde42ec6c15f7ff93d421e7a842fdb30ee7951b1dbc4aacaac06eac764b48"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "1fdd92c2c0dc8440f5387f3d565dbbf989c78c47c34fcefd3de2cf46c2421340"
    sha256 arm64_sonoma:  "8cf485e6165d5f4fd5c9b0ea715ab9fee0b774b8a378d5c6d1102206eb9b51de"
    sha256 arm64_ventura: "8e914b80eb43ff46dcf247fc3972d9e208e8693dbe1fe33eeff1d7b3f6defe1f"
    sha256 sonoma:        "08363d46dc27e5b78a2867141d57c14119395783270055966de604d57c303fe2"
    sha256 ventura:       "331126108ce4e1ed617e8e12bf8888ff3dd5af91e7bd72d07d93113ee005ebd5"
    sha256 arm64_linux:   "868a69a03072742a511683c5801b58969eba4aa3310df0ee7e45304448b56db7"
    sha256 x86_64_linux:  "08c7b78cf6ade20b06817945ccd19a39f31129a672a7aa02672f50e2d2c6fcce"
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
