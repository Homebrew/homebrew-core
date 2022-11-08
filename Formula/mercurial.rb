# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.2.3.tar.gz"
  sha256 "98d1ae002f68adf53d65c5947fe8b7a379f98cf05d9b8ea1f4077d2ca5dce9db"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "e823c9b884da706a578928fb0abf85329f60373e7f44ced7f1a6c03922e4c509"
    sha256 arm64_monterey: "a49666563c4bce1c686cd341a98e3de39fc1182d05b112f7b5f354cc549f97f9"
    sha256 arm64_big_sur:  "236b95b4e1e204b2bd5de22594575d229b250b334dc368d1df63445117a290f8"
    sha256 monterey:       "e325215785cb49120fc3b6954e4ec478d087b45d57e0e1af92b56980ff21602e"
    sha256 big_sur:        "e9b38e850882726fb6a1d9f043bde66cc8aec9209fd483981209bea4442dedb3"
    sha256 catalina:       "c7dc1b0e1b941762460f845ca2d1f611cd84220b8dfd2054f1b07259a5b5fe3b"
    sha256 x86_64_linux:   "3ed906da227f2e21134d98054d183176fb7fbd73c0284f2f766f64ecb8fa5a0c"
  end

  depends_on "python@3.11"

  def install
    ENV["HGPYTHON3"] = "1"
    ENV["PYTHON"] = python3 = which("python3.11")

    # FIXME: python@3.11 formula's "prefix scheme" patch tries to install into
    # HOMEBREW_PREFIX/{lib,bin}, which fails due to sandbox. As workaround,
    # manually set the installation paths to behave like prior python versions.
    setup_install_args = %W[
      --install-lib="#{prefix/Language::Python.site_packages(python3)}"
      --install-scripts="#{bin}"
      --install-data="#{prefix}"
    ]
    inreplace "Makefile", / setup\.py .* --prefix="\$\(PREFIX\)"/, "\\0 #{setup_install_args.join(" ")}"

    system "make", "install-bin", "PREFIX=#{prefix}"

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
    system "#{bin}/hg", "init"
  end
end
