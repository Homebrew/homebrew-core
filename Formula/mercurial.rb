# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.0.1.tar.gz"
  sha256 "05fd0b480389c96547f5a6c769e90ee00f1d13f7ac0d465e40a381c6cf3a56e2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "5d96c4c0b61e43c16020e233d8a839c71ac424c00a283ed346665c6ee12dfea1"
    sha256 arm64_big_sur:  "9ea27510cb027216c137e66bcb40413f08902a29a1eb562049ea3f7b3177b5ee"
    sha256 monterey:       "f8e8d1d9e6fdb4733d47a7888e0b96e603ec5fbfe0c9c58a8dde78061370b822"
    sha256 big_sur:        "0ffe9282a937148f15560445eb2777ad51fbad50281373189b8a45bf8a864022"
    sha256 catalina:       "bec29efc4a41af0657f0cc1256a45a0f1572f1ea4b62d7a9d30d472ffb0b7ddf"
    sha256 x86_64_linux:   "717f9a929cbc17c2ea40323b5e369c9f4dece0515b17a1d1e4f033abb4e5f921"
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
