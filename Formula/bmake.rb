class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20170812.tar.gz"
  sha256 "cdd9ea1aa5b84b7b892ddf2dccb1c21028de6ce0edf5684432e1f4bf861179c6"

  bottle do
    sha256 "846ce0ffbb9edccf39901b5acc09ca52b636702c0fcf8ca80d569e9e30214da0" => :high_sierra
    sha256 "3f6b5a11ed609280af0e27709c78697cfaeeb9d6f2fa6990c1c876224be15117" => :sierra
    sha256 "3b1844361e0706952f4b711a0116721d9de1458cf0abff8d932ea8dae64daaf3" => :el_capitan
    sha256 "a4db2ef119d1bb0cdc25afb620d4142f438343039dbf9c6627c67ef10d723963" => :yosemite
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
