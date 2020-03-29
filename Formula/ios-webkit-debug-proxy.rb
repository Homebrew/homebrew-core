class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/v1.8.6.tar.gz"
  sha256 "9f0a69fec1216ac947991bb1e506cc97f130ae14cef1fc5bbce08daaea566b63"
  head "https://github.com/google/ios-webkit-debug-proxy.git"

  bottle do
    cellar :any
    sha256 "3ca89008434806fe0c2f09520f77d4d8a1e66575dd0102811becb3f1fb97b950" => :catalina
    sha256 "a6084c7a8ec82117e56297855a7e8f0ffa4e47ca5c159c06cc1222e880cd54e5" => :mojave
    sha256 "50c85e10078bed03729ad833a70a499c68e531012ec644fb6fd180243d091088" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on "libusbmuxd"
  depends_on "openssl@1.1"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ios_webkit_debug_proxy", "--help"
  end
end
