class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20171118.tar.gz"
  sha256 "c379ed09ee64277a11296fa93545abf963a059c98630ddfc47dcef9572391a9d"

  bottle do
    sha256 "8ebb9de2730548b157c50f3c8e3b6967e69670488a50b6859b84a8b9572e38c2" => :high_sierra
    sha256 "a35614fd313244edb770ee88213548e0554a10f06c33ce0ee5b45df149e81488" => :sierra
    sha256 "16068a18813d7c2598350ae5360914539a29d4fcd9963d9186c766cc7b3843d3" => :el_capitan
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
