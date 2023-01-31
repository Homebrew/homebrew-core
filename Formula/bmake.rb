class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20230127.tar.gz"
  sha256 "6056866f69496699c815b2af7144701fce7f1ccb6a4743dac5d221ff157d8915"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2617f811eefa87c827ab9790d0dfe768ff7ae0585a25d37eaf79d3716ddea50d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75dfd1bacbf6eb0fc0ece7719193861902d65fe2e022a1a0cfdb4fd33da25de5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a6adc1246ded07b39a12560f7afe9ceebb949b38f26fedf16dd9d1646a1906d"
    sha256                               ventura:        "b6b4112e8ac33eb9451614d1ce07d5dceb5d4c869d8c425d19fa5f2e5d0e30f9"
    sha256                               monterey:       "54015a45174f7d997561036bcf8945d1d1ffa586701d7f5cc597b753585f232c"
    sha256                               big_sur:        "59e076443a130c9a1a53bb8deb5418d6d2ff0025021ae008d4a35e7962704930"
    sha256                               x86_64_linux:   "59e4e63868622325efa4c29bfeee67a3e2fa75aa6333821aaa9d43b0a58094e4"
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
