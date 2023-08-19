class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20230723.tar.gz"
  sha256 "c42a0d951ba23f7665331309fbbe21edc01136a23cb9416850b4315be5fb5904"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db6d49c2869b56201f7958b09873c5a66b6733cee34007c74420a92ee40bd5bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4694103963d57b5163e5fa248d03bffc68b9e884803f6c734ce59672cf43f8b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3c15073cfbae005e99ad980551ab56c9b66fb73bbe229522c191364b1a7eb08"
    sha256                               ventura:        "7adb54794d81332d95d744a8eed5ffbffc6043fa3c562122ba11d559ecab9c15"
    sha256                               monterey:       "8744baafb6f2413df4777185b253d96ac00a6732bf8349dc0562227229e7be26"
    sha256                               big_sur:        "72fe87d4361be9f31ed1141a81ae90f3925b84e9a9ea1879cd09258ba0a56eef"
    sha256                               x86_64_linux:   "574792eacc0a610a05e7f6aca7bc9ac658ec80308007ba021928af605d615de4"
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
