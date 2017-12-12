class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20171207.tar.gz"
  sha256 "1703667e53a0498c0903b20612ebcbb41b886a94b238624cfeadd91a4111d39a"

  bottle do
    sha256 "3e2a1fc2f9770c9606944b9ea2d23dc72df88df68ed3f43f3d9813e33990e7a9" => :high_sierra
    sha256 "9497a6854e972ac0654d42ba901098d6c86ca427eb6e9098a5e971be54e541ea" => :sierra
    sha256 "5fa48bffe37432adc669af7fb3174cad369732f7fed09c0191bf58f12a9e7639" => :el_capitan
  end

  def install
    # Don't pre-roff cat pages.
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install"]
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
