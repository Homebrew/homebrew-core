class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20170711.tar.gz"
  sha256 "32acecefa4fc208df29a12f8441e225a5c9e602070888e6e649bc26a315981b8"

  bottle do
    sha256 "19500ae09004d53ebf685af9aef205457e809aa188cd148431a4ce463078075e" => :sierra
    sha256 "5eaafa69f0314746a18867b40a9d189ba360ec9ef0a5cf0aa16b53ecbcea57ff" => :el_capitan
    sha256 "3af8e2503f182b5023726658cce725a9434b7c0644a62fc6fff1e9e14d447d9d" => :yosemite
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
