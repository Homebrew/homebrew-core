class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20171207.tar.gz"
  sha256 "1703667e53a0498c0903b20612ebcbb41b886a94b238624cfeadd91a4111d39a"

  bottle do
    sha256 "af6993a2cb91919628094ea658f82dda2b312018d7883fc4b44a839737dbb4b6" => :high_sierra
    sha256 "36a131008ff38b3248bc0e885656525f607306812404dabcbb2bd2bf35246c4b" => :sierra
    sha256 "953485657cd8d73a98660b708687b1b8f4ad0adee9cf6c81cb2ab19485624aae" => :el_capitan
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
