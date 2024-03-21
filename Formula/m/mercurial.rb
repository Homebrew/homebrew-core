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
    sha256 arm64_sonoma:   "4a8d8102d5d69314b65534b72fed00f3863ef3140e5bd641dc04a2c7845143ad"
    sha256 arm64_ventura:  "b991376fa57e2bb5538c6e3a60e5be735b52c7b1e3e27b21e727fce5cf0a33aa"
    sha256 arm64_monterey: "ea88427401e7bd437210ab59550ec03316d506dbe7601bbc6e0cf5665b341422"
    sha256 sonoma:         "215468cea73b95e751c059e952aa21f056da8f0c76879af4b77d9e7d7726dc6f"
    sha256 ventura:        "e9611d24c2f18542ecb8ffc4f0b267ab9394522b00f0284a8180297396cd42c4"
    sha256 monterey:       "e0a5b5d89ca02190eefcfdd13adeaae5e731a457b5d9e89c0e29f7ce04730e9b"
    sha256 x86_64_linux:   "71784c11639fe5e7f75552719b1762809db2a2806a7b268ce0b76896ab8f962a"
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
