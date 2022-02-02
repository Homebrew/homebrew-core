# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.0.2.tar.gz"
  sha256 "5fb4c36d3856292ebf584051d59306d96ad8aa32b5537452b1d9c476f95ab11a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b5115b0a14e53cb0cb32131045d1d2fd043fed4cd946c42b414d697ac8743c3a"
    sha256 arm64_big_sur:  "392262fec40ddf0d3fc016fc8d0c30eb1b04ba9177608cc3d088b2a2eb57226b"
    sha256 monterey:       "77c591a0fae48b486f9bf0cd31e905a37f5b871dfd9ef48b0b76b4d4e8a70800"
    sha256 big_sur:        "dcf207690c1b76e32a52988c12afee0a2497a968c43d4e343b5fe169bfed069c"
    sha256 catalina:       "04d7ec4638c0f6ed7e2ea0072a6f650de4b279cbb7fc012e8cd4a41e0ecd2a3d"
    sha256 x86_64_linux:   "ec530c6cc6393c56306a0c5968a0b9dbaee1a128db018be9a7ac7354cfd959c7"
  end

  depends_on "python@3.10"

  def install
    ENV["HGPYTHON3"] = "1"

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
