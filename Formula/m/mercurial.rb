# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.5.1.tar.gz"
  sha256 "33f7de8d8b3607fa2b408cde4b8725e117eb0ad41926a787eaab409ca8a4fc2f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "dce0b4b198aa2ca4c72f11241e13f9fc4af2e1cfd5c2c05e6fc71cac4f4b9aa9"
    sha256 arm64_monterey: "79c5c1e2f62a404dab949c918a7e27cb65ede38c891a9e94c96ea98c403d245a"
    sha256 arm64_big_sur:  "e7715a6d5ae02fd1470e639f3acbf665ddf01bd7ea1dbc0e2e653fee04af53bb"
    sha256 ventura:        "275751b65ce8f1be29d5238178b466227ccedccc1234b9b06bb0e22d41b1ee5f"
    sha256 monterey:       "b4871fb5add36b8e31b85be868d1389f09de16a3ead6caf9c9026e45e9e6a4c0"
    sha256 big_sur:        "4eaf78c19a85722f0cf92f7cbbff98207302f3a8e82ed0c59ecb37ac909d9c56"
    sha256 x86_64_linux:   "a793c0ed8f469ae60cae89045c336dfd5764f29952b13c4646d0a7941ac54777"
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
