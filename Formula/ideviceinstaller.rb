class Ideviceinstaller < Formula
  desc "Cross-platform library for communicating with iOS devices"
  homepage "https://www.libimobiledevice.org/"
  url "https://www.libimobiledevice.org/downloads/ideviceinstaller-1.1.0.tar.bz2"
  sha256 "0821b8d3ca6153d9bf82ceba2706f7bd0e3f07b90a138d79c2448e42362e2f53"
  revision 4

  bottle do
    cellar :any
    sha256 "a67c1699f0c03461f57e2232b44d175f2f38f4288ac3a3db6d92f90e299da786" => :high_sierra
    sha256 "4651061aec01678c5feb365acc989aa211602cb62e32a1498bd4a52de217aa82" => :sierra
    sha256 "8821769d4434688cc64aa3e63bb4f426d37d416b2dca3c935f1293ae1bddad22" => :el_capitan
  end

  head do
    url "https://git.sukimashita.com/ideviceinstaller.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libimobiledevice"
  depends_on "libzip"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ideviceinstaller --help |grep -q ^Usage"
  end
end
