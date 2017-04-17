class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20170413.tar.gz"
  sha256 "c92085c9caf6c95e2d4d16a3728bda5b711f44e1d3270c1ad996c51cba19e230"

  bottle do
    sha256 "96808a031b4ec41c3e6b0db5306b04433d240a3368335037a5ea6c9c2fb45513" => :sierra
    sha256 "c386ecd4ad69b36fa3b77d45b5605c3f94c348e32743a8099fdc1ce72c09e5c7" => :el_capitan
    sha256 "3e371590a9cb3d571ca77c3cd280bb352940e05404717e799d469d41296ead6e" => :yosemite
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
    (testpath/"Makefile").write <<-EOS.undent
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
