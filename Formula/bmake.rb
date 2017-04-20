class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20170418.tar.gz"
  sha256 "889bc3fb119d268870e97876ff764591d5c5f187ef0f4055399c77a32526e809"

  bottle do
    sha256 "eb7a33b578eb950b0e70669800275e69ebf3f16dac791cfdb17c92936d78ad4c" => :sierra
    sha256 "8c13a0bb6f03636d57aa8e85e5505ad4895f2c1a1ed8ceba350de6fbedd51285" => :el_capitan
    sha256 "a905c4a94bec3086877469e3a34b5aef1836314a689a7814b57aa161353d00bc" => :yosemite
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
