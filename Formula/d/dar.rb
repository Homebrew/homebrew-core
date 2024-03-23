class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.14/dar-2.7.14.tar.gz"
  sha256 "40d4dba44260df3a8ddce1e61f411ea9ab43c2cfc47bd83ab868c939d19dc582"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "79faef259c0d53438d62e448080bd0b43ebf91a5d08166256c42fb1a6a121f56"
    sha256 arm64_ventura:  "578950a4f7d2c08b07661414bea515e3c9f04748f372f7f13c96b2f6689a6b7a"
    sha256 arm64_monterey: "dba12c07665fbfadf24d50e773555552730a7c2adbb04f9074303cba7db042b8"
    sha256 sonoma:         "12447460314fdebd367f4b0c23f3a43343d1e63daddb903d4481d64e16de4e76"
    sha256 ventura:        "d9bde386d0f3e4b6b6c426b8723047f2550df3d36c13dd8b358c276d5dd1ca52"
    sha256 monterey:       "3832482d20a969113fc4fe3db3cadc23568711bc250728673870cb58045e9159"
    sha256 x86_64_linux:   "948d8e31cba588405237c54501feb2a3187c0b2019afab9d30898ecd1d6f98b7"
  end

  depends_on "argon2"
  depends_on "libgcrypt"
  depends_on "lzo"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-build-html",
                          "--disable-dar-static",
                          "--disable-dependency-tracking",
                          "--disable-libxz-linking",
                          "--enable-mode=64"
    system "make", "install"
  end

  test do
    mkdir "Library"
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
