class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20200629.tar.gz"
  sha256 "45d79202320a3a2d03dbb0fe87ecfd87751cb5db7b4e5c3abfcf5c85c8d7b5b3"

  bottle do
    sha256 "886b5ffb2e30376d34055f5be095492bd2785d0db40f6e8614a7e7a5b44959db" => :catalina
    sha256 "ff919e5a081fc27c0b4ebc93c1a44ec096b1dcf2818faa4fe79e220b5c3ae1d7" => :mojave
    sha256 "c2dc9c5f51d0114a4402192f43bf3bf634e819c796c98e90d81e4d6ee35ecbe5" => :high_sierra
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
