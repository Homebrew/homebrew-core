class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.6.9/dar-2.6.9.tar.gz"
  sha256 "db48f5beb0671afc4443730910e010d7ba846f4b1912491b163db6c049c1f8cb"

  bottle do
    cellar :any
    sha256 "f05679ced5d121523f008a3a2eb9dc0b1da35f09a1443d6233577343d26dfd02" => :catalina
    sha256 "9f4b02440b3711787ca24c5bf9901654093f7c4364bfd2c9f9c45413c6880cd7" => :mojave
    sha256 "d372eb12e3b783c910d4fc31d834e4dd61104dadc6e63dd273829951af66fd55" => :high_sierra
  end

  depends_on "upx" => :build
  depends_on "libgcrypt"
  depends_on "lzo"
  depends_on :macos => :el_capitan # needs thread-local storage

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}",
                          "--disable-build-html",
                          "--disable-dar-static",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-libxz-linking",
                          "--enable-mode=64"
    system "make", "install"
  end

  test do
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
