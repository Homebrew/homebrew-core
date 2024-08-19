# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.8.1.tar.gz"
  sha256 "030e8a7a6d590e4eaeb403ee25675615cd80d236f3ab8a0b56dcc84181158b05"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "7e9916632146a76c3fa34f285354914d50b69b5dab7781f50d1506006e7dcb36"
    sha256 arm64_ventura:  "e4da6f70ba065c491af1ed51fca882d2df31f83ee48e22447911656d23150e56"
    sha256 arm64_monterey: "e1917cfd510fefa726349a35fcf6c61416b6b23937bbf33adb57c0d11a97dfd1"
    sha256 sonoma:         "c991c86e05628e89b8faed78ccd12c3604dc776a7e2c97779489b1ae46104826"
    sha256 ventura:        "1274f63a129b7484b010da27e73a35e028dfcf5af30bf51c14e9c85a9462365b"
    sha256 monterey:       "fba48480e228cb68950b39f3d21cd155d1317e8a915a4eae289a20d7d64d9187"
    sha256 x86_64_linux:   "d7f3cc98cca1c75f5e74779f5c6dcc404337ecb4f42e462b78922b5d44ad6720"
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
