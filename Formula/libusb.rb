class Libusb < Formula
  desc "Library for USB device access"
  homepage "https://libusb.info/"
  url "https://github.com/libusb/libusb/releases/download/v1.0.22/libusb-1.0.22.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.22/libusb-1.0.22.tar.bz2"
  sha256 "75aeb9d59a4fdb800d329a545c2e6799f732362193b465ea198f2aa275518157"

  bottle do
    cellar :any
    sha256 "6accd1dfe6e66c30aac825ad674e9c7a48b752bcf84561e9e2d397ce188504ff" => :mojave
    sha256 "7b1fd86a5129620d1bbf048c68c7742ecad450de138b8186bf8e985a752b2302" => :high_sierra
    sha256 "7f2b65d09525c432a86e46699a1448bab36503f45f16d6e0d8f42be6b1ef55cf" => :sierra
    sha256 "33575c9f56bc0d57bf985a21e40be019d5c269b432939416be8f24c5921bbb28" => :el_capitan
  end

  head do
    url "https://github.com/libusb/libusb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-runtime-logging", "Build without runtime logging functionality"
  option "with-default-log-level-debug", "Build with default runtime log level of debug (instead of none)"

  deprecated_option "no-runtime-logging" => "without-runtime-logging"

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--disable-log" if build.without? "runtime-logging"
    args << "--enable-debug-log" if build.with? "default-log-level-debug"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples"), testpath
    cd "examples" do
      system ENV.cc, "-lusb-1.0", "-L#{lib}", "-I#{include}/libusb-1.0",
             "listdevs.c", "-o", "test"
      system "./test"
    end
  end
end
