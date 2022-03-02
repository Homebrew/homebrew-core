# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.1.tar.gz"
  sha256 "86f98645e4565a9256991dcde22b77b8e7d22ca6fbb60c1f4cdbd8469a38cc1f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "a494de979086f1b68c37d69d937bd449c82f1f177bff79408c99409902eefaca"
    sha256 arm64_big_sur:  "482bc63c3efa83e0def96acd70a849dd2443974f18a3200bddecd20de61277db"
    sha256 monterey:       "a79aaa9c19621cb0bc2901bbc10489bed018d6b2e1f18470ac6a313d58e4d992"
    sha256 big_sur:        "e94ec8b0a97a8985b0ba5fbfa6d80bc63849984c4fbaacc9a34712324d310a62"
    sha256 catalina:       "4bbafb7089a2cf90dec695225ed9ff9c5c0e482a68548e744a585d5c1aee3704"
    sha256 x86_64_linux:   "d3492d0ec0c1d4a6fccd014d1dfe01279c2b0efc6549bc6323eb73d090f93d74"
  end

  depends_on "python@3.10"

  def install
    ENV["HGPYTHON3"] = "1"

    # FIXME: python@3.10 formula's "prefix scheme" patch tries to install into
    # HOMEBREW_PREFIX/{lib,bin}, which fails due to sandbox. As workaround,
    # manually set the installation paths to behave like prior python versions.
    site_packages = prefix/Language::Python.site_packages("python3")
    inreplace "Makefile",
              "--prefix=\"$(PREFIX)\"",
              "\\0 --install-lib=\"#{site_packages}\" --install-scripts=\"#{prefix}/bin\""

    system "make", "PREFIX=#{prefix}",
                   "PYTHON=#{which("python3")}",
                   "install-bin"

    # Install chg (see https://www.mercurial-scm.org/wiki/CHg)
    cd "contrib/chg" do
      system "make", "PREFIX=#{prefix}",
                     "PYTHON=#{which("python3")}",
                     "HGPATH=#{bin}/hg", "HG=#{bin}/hg"
      bin.install "chg"
    end

    # Configure a nicer default pager
    (buildpath/"hgrc").write <<~EOS
      [pager]
      pager = less -FRX
    EOS

    (etc/"mercurial").install "hgrc"

    # Install man pages, which come pre-built in source releases
    man1.install "doc/hg.1"
    man5.install "doc/hgignore.5", "doc/hgrc.5"

    # install the completion scripts
    bash_completion.install "contrib/bash_completion" => "hg-completion.bash"
    zsh_completion.install "contrib/zsh_completion" => "_hg"
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
