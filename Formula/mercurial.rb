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
    sha256 arm64_ventura:  "c51c71de5c4654529f09e47dab8212344650eec7fc971110fc605a90e39a3a22"
    sha256 arm64_monterey: "0eeebb2d0934cb62cc4d0bfca0832c8c923c459e8765a26ead0465a85ea43d67"
    sha256 arm64_big_sur:  "0b3b55dc103c8fa403ca6570ed017375d9161f062558a4a0b18607ac3e59fafb"
    sha256 ventura:        "17c84bba802ac6b71ea55dea2a839a1dc9ccf4e2e83b4ee08cede23e0ea259e4"
    sha256 monterey:       "4eb9a86235f22655a9cad34f18e537e7dcbeb30292f1ce5b64d7c430e6ec15cf"
    sha256 big_sur:        "6d7b3f4d6b91fd47858788eff73d45f8239b66204fe8e2045004604ec0d11a21"
    sha256 catalina:       "660f3b10a2b76c87c75baf88f0fcf31a4ab6d2917fbbdcccf96386dd9b08e40a"
    sha256 x86_64_linux:   "2b2cd69c69a3fc3199e4271c7ed5b9610943005c24f210c9b390093c8e8972ba"
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
