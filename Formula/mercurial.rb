# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-5.9.3.tar.gz"
  sha256 "3b43f68977ad0fa75aa7f1e5c8f0a83ba935621ab2396129abb498e56d1be08e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "9b1349a8b2d1b397efb62208a0ebc392f3e48d12deffa98a088107f1a375e3e9"
    sha256 arm64_big_sur:  "9c02fc659c9eeeb0f20f8a24dc49c6e5ef42b3209ccb0bfd85363088aa6c08f6"
    sha256 monterey:       "5111c7dd5bc919ed38b83cd53b753a49c3c73991d06edbb9024fa6f350b81fa7"
    sha256 big_sur:        "28f6409aa8a97a07cfd8645e2896dd3bd52bf8747bcc6c9639470d4c60f5d1c9"
    sha256 catalina:       "0c7452ab96ef48dca8516b7e478e96bf92d8ae24ce86f86adbb7529f4d681b4e"
    sha256 x86_64_linux:   "9edd2f30244f0519103dd7f4786cd51df10b8be1cfaf3296b4f5455469104063"
  end

  depends_on "python@3.9"

  def install
    ENV["HGPYTHON3"] = "1"

    system "make", "PREFIX=#{prefix}", "PYTHON=python3", "install-bin"

    # Install chg (see https://www.mercurial-scm.org/wiki/CHg)
    cd "contrib/chg" do
      system "make", "PREFIX=#{prefix}", "PYTHON=python3", "HGPATH=#{bin}/hg",
                     "HG=#{bin}/hg"
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
