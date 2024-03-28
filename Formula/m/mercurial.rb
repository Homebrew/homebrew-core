# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.7.1.tar.gz"
  sha256 "9b0eda5d0d0ddb8b31e9c76aa06fc55fd2ffb02bc3614de0b1437336b2fc1254"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "15d4961fb9c58069ecbe31b3bfc47f0f8c67eaddd51d69e892733f8dcc1e5fa2"
    sha256 arm64_ventura:  "fd1f804ce76f01df5257475eb2379e7e23f594c69f975bc3622c37258d11b21d"
    sha256 arm64_monterey: "8012cd1f205e9bdeb3f3a2ff0e157a4261786196a2a56a50550e4ff685b91726"
    sha256 sonoma:         "1d96eebbd407a413abf6bb285f038039064f60107f9b5a44a36ba4fc6358bd33"
    sha256 ventura:        "978045f0b709ddaf8872799524850ffe763b8d0682d552dffd59c891ee1b4046"
    sha256 monterey:       "373bc54ad5ffbd33fa9ed19a4637cd6cecefbddc8e4a21e2f433c643f02e136e"
    sha256 x86_64_linux:   "411534f44366078ea82155cbf29ded4ee4b3e109ef1bb31c2c0daef142471661"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"

  def install
    ENV["HGPYTHON3"] = "1"
    ENV["PYTHON"] = python3 = which("python3.12")

    # Homebrew's python "prefix scheme" patch tries to install into
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
