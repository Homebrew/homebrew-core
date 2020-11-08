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
    sha256 "c56f5e5f3cc860153be9610eabc2f7b78dba1463379f0470f86ba727e7ffe458" => :catalina
    sha256 "3038599dec9f89b2ba24aff34d34b374ab39223bb318b1bacfac9a5860ad11df" => :mojave
    sha256 "8dcbed6d25b95a10b8260c9e848c0d5c0322475cf06ec639ded58dd1314ac6cf" => :high_sierra
  end

  depends_on "upx" => :build
  depends_on "libgcrypt"
  depends_on "lzo"
  depends_on macos: :el_capitan # needs thread-local storage

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
