class Libusb < Formula
  desc "Library for USB device access"
  homepage "https://libusb.info/"
  url "https://github.com/libusb/libusb/releases/download/v1.0.23/libusb-1.0.23.tar.bz2"
  sha256 "db11c06e958a82dac52cf3c65cb4dd2c3f339c8a988665110e0d24d19312ad8d"

  bottle do
    cellar :any
    sha256 "52d3e0d6005ea2fdff5d2c28b972e33f84885f7b1ff9ede3a5603b4f7c332a3e" => :catalina
    sha256 "31b858cce5431f2298524d4e676191477f1e67ee7dd09d02b356cd1219a53c5a" => :mojave
    sha256 "790457dfed646369ee40a2cf1a67f47bc61dbae123b8a4c4937296ae640ffa30" => :high_sierra
    sha256 "600db569dd82dda3e492e53c8023093d003836329b614cea8064ab68d20aca0d" => :sierra
  end

  head do
    url "https://github.com/libusb/libusb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]

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
