# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.3.1.tar.gz"
  sha256 "6c39ab8732948d89cf1208751dd7d85d4042aa82153977451b9eb13367585072"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0ffb8b179aa7557fc22da21da69e1627ad515241e2ebd450941e695a421b4841"
    sha256 arm64_monterey: "25d88c7f8c59c40f6fb0719041d14ceb79de888e9750d8d57db61d6541a484b5"
    sha256 arm64_big_sur:  "b303d2f44d6a40c46aadb006da944a3b27518d5379cf234bf031f8f88ac3e937"
    sha256 ventura:        "c6559ed597d308ddb0a224e257f8af33364cc1cf1e05672677d27f4029418cb3"
    sha256 monterey:       "5bf2ea3e097a6dd9d904a13a11ac3866dc786efeae060a967792e121d136e18c"
    sha256 big_sur:        "5ad92094b41ecb6d8fa96b9f5ecf3d928fa670426b07052f96cea0e70042db6f"
    sha256 catalina:       "a370e26e8c81a663ab3ddff0b89b4a24a4661975e40e36d401ebd8310cade85e"
    sha256 x86_64_linux:   "0d100f0b6ba45981c21f9f1ba6bd4a9f76881f288cf6a44eaf9edb0330d34bd3"
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
