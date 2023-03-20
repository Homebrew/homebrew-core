# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.3.3.tar.gz"
  sha256 "13c97ff589c7605e80a488f336852ce1d538c5d4143cfb33be69bdaddd9157bd"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "3fe0310976e30934b3fdc9f1ce0bb0ab6be05552777f144418a866248c9a1e1a"
    sha256 arm64_monterey: "2c53a84c001384a6cf4f41ed654f488a9445ff6e15e58f7fa83eb267f8b8fffc"
    sha256 arm64_big_sur:  "8dbc4f00b16223daee8d59b8a38d72554c97515226624659af2b651db596133c"
    sha256 ventura:        "86c67bdcafb094da119f7938a1541d15624b573ba33ac8453b7279d652860785"
    sha256 monterey:       "93237a3187b9459e7442ea28ae03ac400b096396262dcb4509791110d8acf50c"
    sha256 big_sur:        "94fca0e8e657c128bdd3d09a2039100c81dc900e1c05d6a6de2931de0577c516"
    sha256 x86_64_linux:   "e6438bb22c743b3f42b4933d20e72f58517b1db4ad79680b5a376a2ac85cca89"
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
