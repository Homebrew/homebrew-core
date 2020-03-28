class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20200318.tar.gz"
  sha256 "657cc5995ab60ef64fa6f460711df677e1685e54bda84096a85d9506c17e2c83"

  bottle do
    sha256 "dcb2b1df805baa7c1d93feb57f59222c6e84b160e85a4d34a9cd0e5994125686" => :catalina
    sha256 "3e2702ce0e03d67dab589e1e8b3feb3d9db96e57d80b9f483a71ddee6a1fc846" => :mojave
    sha256 "40f816e6a097069084e5c053e31bfbce1c3067e58579c1c34f2e63c905e700ff" => :high_sierra
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
