class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/1.8.tar.gz"
  sha256 "5a5ba157e76d984978f3f3aa22617b0c3c730d15e1a4d23a77c12e4a581189af"

  head "https://github.com/google/ios-webkit-debug-proxy.git"

  bottle do
    cellar :any
    sha256 "d62c288078faece5ce96abccb6b83e39ee264bdb562bf08fca7ecf6f6ab36836" => :sierra
    sha256 "70049a0d07821e40fdc80d1274180dbfef1569a7bda8a0f4ff7c75a094aedd0a" => :el_capitan
    sha256 "46803211b51643b21a33e8dd1f362ac9450c5bae7c9d6ad1976decc66584d180" => :yosemite
  end

  depends_on :macos => :lion
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "usbmuxd"
  depends_on "libimobiledevice"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ios_webkit_debug_proxy", "--help"
  end
end
