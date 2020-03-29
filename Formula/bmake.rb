class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20200318.tar.gz"
  sha256 "657cc5995ab60ef64fa6f460711df677e1685e54bda84096a85d9506c17e2c83"

  bottle do
    sha256 "32698f51f0ef6bd8802a01ab1df69cb24d194d6fc4e494dbfaa6f33cb8f7ce2a" => :catalina
    sha256 "ed6b38e57d7f544cb6adafa9b77ba2b1672d6759bcb3f9f40560d9b134806075" => :mojave
    sha256 "53a30848b6959e2ade0adccdb7fe714d229f34fc71feb18be2bde3e42848717a" => :high_sierra
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
