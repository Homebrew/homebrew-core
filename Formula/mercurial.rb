# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.2.3.tar.gz"
  sha256 "98d1ae002f68adf53d65c5947fe8b7a379f98cf05d9b8ea1f4077d2ca5dce9db"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "13554d637c035c3e131d382625267c99a851e2de085877edefb9ea6bdfb8a0f6"
    sha256 arm64_big_sur:  "3858b593fe71f88039e12cadbad1e45dbd9e5a19019bc4c3445bbca3a5b3c3f0"
    sha256 monterey:       "724b8e27b78610887aeffc87a798537f2bcd9fac9770fddc6a821adc29c0dfe2"
    sha256 big_sur:        "d4ad55af45adab9a3fcdc55bf1acdd30ab1006928e20335060eedc527a61a1d1"
    sha256 catalina:       "d9ddf3a6557a3b5ba59ca2c497306f282d4b95c9ccac1fff12086fc14e9452e1"
    sha256 x86_64_linux:   "90a5366187dab6d5f61fa60a9a7c5d0e56a4c33f52b534b860ed9025f7ef87c8"
  end

  depends_on "python@3.10"

  def install
    ENV["HGPYTHON3"] = "1"
    ENV["PYTHON"] = python3 = which("python3.10")

    # FIXME: python@3.10 formula's "prefix scheme" patch tries to install into
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
