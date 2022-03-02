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
    sha256 arm64_monterey: "5e51a0d69393e675bc945a4dbaf94986d0bf699f9305af0779d3c79e011291b4"
    sha256 arm64_big_sur:  "227c1ed84490c3ffc480729acdfbfb956286577e8aad582b7456cd4a8a538649"
    sha256 monterey:       "24d16d7071fc552dbffa7f43a5ed6f09abce0616ba33ca61fdb1e8c560ef6b5e"
    sha256 big_sur:        "b9005e9a4c7a45d0f8cd20d957d988c3e3814c5a62c6dbdf6ddcae5f99050e6e"
    sha256 catalina:       "8728f55a40244173cbc538b6df6a449da55e166803db1f15d3438eee74d6532a"
    sha256 x86_64_linux:   "d3118f170ca153846bf4aecfe57f8b8109b7a0c7802217ae08ba6e6766309ece"
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
