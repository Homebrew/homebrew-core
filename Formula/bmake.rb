class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20200629.tar.gz"
  sha256 "45d79202320a3a2d03dbb0fe87ecfd87751cb5db7b4e5c3abfcf5c85c8d7b5b3"

  bottle do
    sha256 "de69252496f393c24b4a1e10022e2ea96e5701bb73676e3d89af5fe81f8aa472" => :catalina
    sha256 "f18586815fcf1f38ed6a3d7e3352983cd203274d5484db8bad34b40cb1c6ca53" => :mojave
    sha256 "b7736fb9821864b5333f4d4e4e843a33a9607678445cf18251ba0635c7ba23b4" => :high_sierra
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
