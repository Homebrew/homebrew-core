class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.5.12/dar-2.5.12.tar.gz"
  sha256 "19bd60000a681a20386ee079b9a6ea05028020053eaeddbff175a8d22563fba2"

  bottle do
    sha256 "1a6daa86d3cdc0250ddb5cb4a5146f1da10f5ae4bb174bf6297a60f49d04f5c5" => :sierra
    sha256 "6fddbae4c61b7c31719dd563cb74b7169aad8fe657bf440831e231e1a3ffab33" => :el_capitan
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
