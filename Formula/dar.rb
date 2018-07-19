class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.5.16/dar-2.5.16.tar.gz"
  sha256 "e957c97101a17dc91dca00078457f225d2fa375d0db0ead7a64035378d4fc33b"

  bottle do
    sha256 "fe1348b2c7f0a62f3390c7824c1762123b4983fdd2c8f2d695aa296661f7fb5b" => :high_sierra
    sha256 "27f1b1570c263d1e1838b9372b9c5fd3287532dfcd9f7705cd4028e2cad3740f" => :sierra
    sha256 "ecbbfcef445992d0a86862ace0624879bd5ca5c4961d199c4d6451b0c336129f" => :el_capitan
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
