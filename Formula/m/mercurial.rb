# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.5.2.tar.gz"
  sha256 "afc39d7067976593c8332b8e97a12afd393b55037c5fb9c3cab1a42c7560f60a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "2c1cbce9975c564c97b2cca38f7f3936156f42471cc1e82b35885dd79a4904e0"
    sha256 arm64_ventura:  "b55165a71f173f4584fa125924b104c774a817369fcb03bec2eab093c7676ec8"
    sha256 arm64_monterey: "ff85084729bd075861ede0d68f570d88824dc6c1c7b04b8171307cb804b25fdb"
    sha256 arm64_big_sur:  "a9dc023f3096d960872bb70a04811fdfefbefede2c36f2f65cf83fca88fd2d0a"
    sha256 sonoma:         "d785122f7c09bf973799e87eb96e653ae9fa72b603490d32f00e7b457cab1ed7"
    sha256 ventura:        "9a06ef4ce2ce14852ec5a40eb9ffed06cb649b89b304654229d1e98cbba4dff4"
    sha256 monterey:       "5a91a1efb3b25ee6dd70dfb3b74ffd283e45c6eb42b666c061ef76106f38e460"
    sha256 big_sur:        "0bad9b520371939fee2ea16c8b3cd5a93915f18baf2c209d98540f33ea6af9c1"
    sha256 x86_64_linux:   "ab687c12c29f0af2fa836ec4750830217e5b4337d3d6ef8d52720973fba31af4"
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
    system "#{bin}/hg", "init"
  end
end
