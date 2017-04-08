class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.5.10/dar-2.5.10.tar.gz"
  sha256 "771c8462b9e65bf646699a14a4e156c75b5bda4301ebf6f5e03bd82c2486a4d8"

  bottle do
    sha256 "7789e0c92aec4e7c3abcccb61e9d98bc165e7975b781498a693300f7111b93bc" => :sierra
    sha256 "1b3290815718d979b20b49a69aa6f0b9aed8bf203e85f9cdf8bfb631af25c1f4" => :el_capitan
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
