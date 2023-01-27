class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20230123.tar.gz"
  sha256 "6557c48d144a6b531fa26c7273c090c656280ba7b43df376971a5b2cdbe01b2f"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a6c5dc17098776abd3d0146b2699be8d10ad8584a1e8498aaba317ba20033de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c478baa9b979eef9ca091741df73c59377f9d391f6fde5ba9ed7baf4a36851dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33ea137059403926f77326cb3bff5895c3df48110423819243407dbdcaa03f8b"
    sha256                               ventura:        "8c30f2e2eacd0448646c31fb8051fd10c4e2a172a6cdc18eea916a733975f0ee"
    sha256                               monterey:       "9007826284a2a9a1ec3a24f415ff4461055db0d8aa09187fd46fc1afb42824d5"
    sha256                               big_sur:        "399442fd87567a4cdf5e85a84efb9275987252251bcfac55fafd12614eef1924"
    sha256                               x86_64_linux:   "4b3e9f9ad43b212a16241d85f96c3d84683ba2270cc6d153e52b48595eaf98b5"
  end

  def install
    # Don't pre-roff cat pages.
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
