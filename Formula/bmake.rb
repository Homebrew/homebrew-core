class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20171118.tar.gz"
  sha256 "c379ed09ee64277a11296fa93545abf963a059c98630ddfc47dcef9572391a9d"

  bottle do
    sha256 "862a19ea9ef6e409742c1313bbc8393f30692da00061898263d644ea5280dbf4" => :high_sierra
    sha256 "f42ef045b9b5ec7932bf73587de8c5250e543035c6edcc96c1654e0e021bceda" => :sierra
    sha256 "3de3b1e330369f41c1fe064f0e055de704874ab607321e1dba002bf200248fdf" => :el_capitan
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
