class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.5.14/dar-2.5.14-bis.tar.gz"
  sha256 "a5e744f04dde0b3af28f36deccaf274906e1cb29688b9f8bef7c62578b3d6de9"

  bottle do
    sha256 "d9d0a90712f3fe179767ea5caf79a46f4b57702a09b8a55e030e99fab002c800" => :high_sierra
    sha256 "ece73e9dd56771993d6b8aedba32e0035b60866aec58ce85ae70197be1c5d43c" => :sierra
    sha256 "098d2cb0df8236d49a08a11ff0c3fa77ea8817baa2880ac8c473bb816318bf29" => :el_capitan
  end

  option "with-doxygen", "build libdar API documentation and html man page"
  option "with-libgcrypt", "enable strong encryption support"
  option "with-lzo", "enable lzo compression support"
  option "with-upx", "make executables compressed at installation time"

  deprecated_option "with-docs" => "with-doxygen"

  depends_on :macos => :el_capitan # needs thread-local storage
  depends_on "doxygen" => [:build, :optional]
  depends_on "upx" => [:build, :optional]
  depends_on "libgcrypt" => :optional
  depends_on "lzo" => :optional
  depends_on "xz" => :optional

  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      --enable-mode=64
      --disable-debug
      --disable-dependency-tracking
      --disable-dar-static
      --prefix=#{prefix}
    ]
    args << "--disable-build-html" if build.without? "doxygen"
    args << "--disable-upx" if build.without? "upx"
    args << "--disable-libgcrypt-linking" if build.without? "libgcrypt"
    args << "--disable-liblzo2-linking" if build.without? "lzo"
    args << "--disable-libxz-linking" if build.without? "xz"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
