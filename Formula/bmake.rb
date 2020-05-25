class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20200524.tar.gz"
  sha256 "79e72bbab47dad2cfc8e6041a61287fb852109c8e3dc1defc5a2b64e3966dadb"

  bottle do
    sha256 "c417bfec4fcf56f6306832c49af7df3db18a9f27b0c76bc8ac098b2a7a5caa84" => :catalina
    sha256 "6805e7ff1d404e80ab2e4c6801887042e12e8b237ac67118ffa16ee546746322" => :mojave
    sha256 "272aed7e78f19205b325218d93dda79e621687f0e2a6481ba9c23061578d41b6" => :high_sierra
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
