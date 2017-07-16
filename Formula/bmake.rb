class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20170711.tar.gz"
  sha256 "32acecefa4fc208df29a12f8441e225a5c9e602070888e6e649bc26a315981b8"

  bottle do
    sha256 "d3e2259d97f10c26ecf2d91cf548810bf79c40bc8bd45d48ec19954c7e531f93" => :sierra
    sha256 "e0136f28cb039f808ed8e7478dd834681f7c3fabd5cd1b08efa9fb55760878f0" => :el_capitan
    sha256 "acf577519e8ad6fa2c34ff5be0c62c0317b606aa122126392b3a99cba1aa4c26" => :yosemite
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
