class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20200902.tar.gz"
  sha256 "082c0442f03f2dbef8c3171000398c1936047aa0d5a2e1efc2c8474d69403bec"
  license "BSD-3-Clause"

  livecheck do
    url "http://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 "29e4ba42d18ce3e974cf9bd402a17519635ba350c371d3da5672fea14e40fe81" => :catalina
    sha256 "4f0b8d35af1cf7fb1119359a82dffeb84a042e8804f0994b1dd56c8c4a952df1" => :mojave
    sha256 "d0c4003a00e1d40d5273386eb54a0667daa928a78fe5aa03ce4449cead4207e4" => :high_sierra
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
