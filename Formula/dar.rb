class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.6.13/dar-2.6.13.tar.gz"
  sha256 "3fea9ff9e55fb9827e17a080de7d1a2605b82c2320c0dec969071efefdbfd097"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "e3c5b475201e6916f344653c86357a54cdd5bf081a6b5ecc72e1f8cea67bbb8d" => :catalina
    sha256 "3297d386d1572cf82676d96809cea6b54a4338c1a51213c6c059c81206b98c5b" => :mojave
    sha256 "7f44bc4ac5e17f47705f8a338517432690dadcf6e6f9e7cce502624d4849c6ca" => :high_sierra
  end

  depends_on "upx" => :build
  depends_on "libgcrypt"
  depends_on "lzo"

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}",
                          "--disable-build-html",
                          "--disable-dar-static",
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
