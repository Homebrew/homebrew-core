class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20170311.tar.gz"
  sha256 "881bb42230650a6f756ac7a2054ca984f31e1002fe3362456a77631c162ba33a"

  bottle do
    sha256 "8f506a0b2235917a3fb560487f15d4ff12c11df420cbc48f87c606cba1dfc174" => :sierra
    sha256 "d21770b29ee7d89fdccfb581f64a72d2c539f461a5fa7b39f99c82e6a7d7827e" => :el_capitan
    sha256 "c74b0950babcd482037c6660b112171dc0f2a9f1fb419479e3ae6ff045c010aa" => :yosemite
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
