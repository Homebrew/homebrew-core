class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20170311.tar.gz"
  sha256 "881bb42230650a6f756ac7a2054ca984f31e1002fe3362456a77631c162ba33a"

  bottle do
    sha256 "38e0b7712c5ae20b9a2639f21aa46c96e7893e3a44ce8956d1c64f5efb16ed66" => :sierra
    sha256 "6964daaba5e8b288e9b39ee9439821bac54f3babbc619fe9db5c6ae7d81284e8" => :el_capitan
    sha256 "74d7a6b8f7fb23383762be1440171f50336283eebe1f48d7163ae5b81ae4489f" => :yosemite
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
