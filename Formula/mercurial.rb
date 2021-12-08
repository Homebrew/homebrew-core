# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.0.tar.gz"
  sha256 "53b68b7e592adce3a4e421da3bffaacfc7721f403aac319e6d2c5122574de62f"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "73acfd2122f602b764da76d5694f4d652fb249659bf9a67195587a9446075372"
    sha256 arm64_big_sur:  "c05c1171ba3f8dd4dced739d762cb6917b775b029867d1a8c4925ca841887525"
    sha256 monterey:       "37c1a285f5eae584fec4a97c4a540d82076640324370f6357afb635197844c45"
    sha256 big_sur:        "55e663fe6806e6276e9325061100d536a0e10ed4713c01feed4b4bed9d4c802f"
    sha256 catalina:       "587a7e2aeb114f44edcf6503d8a0789fe05db0a85d3a9a29cc628a72fc0b2821"
    sha256 x86_64_linux:   "3e2f28ff2702e50f54199485a43cb3719593ea462ff0ffc0365fd87c02bac407"
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
