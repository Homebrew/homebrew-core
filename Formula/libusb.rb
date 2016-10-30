class Libusb < Formula
  desc "Library for USB device access"
  homepage "http://libusb.info"
  url "https://github.com/libusb/libusb/releases/download/v1.0.20/libusb-1.0.20.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.20/libusb-1.0.20.tar.bz2"
  sha256 "cb057190ba0a961768224e4dc6883104c6f945b2bf2ef90d7da39e7c1834f7ff"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e8510c3a6f5627fdbeda0175885d14f3817cf56205f97e6f6b593718bd539d48" => :sierra
    sha256 "e1a0f90bb8906e3d833b033a4bed058f6aa1700d376971db700c8741527dafa9" => :el_capitan
    sha256 "6a4fb2012bf9106fcf1c71b215b711188d7c88d0d12b2cf744ba966363b2144d" => :yosemite
    sha256 "5a475e2ca93886e51b994d1ea323e915c91d8463e5b23b45203acb69edf69981" => :mavericks
  end

  head do
    url "https://github.com/libusb/libusb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "without-runtime-logging", "Build without runtime logging functionality"
  option "with-default-log-level-debug", "Build with default runtime log level of debug (instead of none)"

  deprecated_option "no-runtime-logging" => "without-runtime-logging"

  def install
    ENV.universal_binary if build.universal?

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
