class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/v1.8.6.tar.gz"
  sha256 "9f0a69fec1216ac947991bb1e506cc97f130ae14cef1fc5bbce08daaea566b63"
  head "https://github.com/google/ios-webkit-debug-proxy.git"

  bottle do
    cellar :any
    sha256 "17eb18d145d9f0de70e42fb00bb7d3d7522ef9565e7462371a3598cd12845b37" => :catalina
    sha256 "44e42a0c9c4c581e19f39b4fe6f8488d0a3b54179e07fc3f2a375b4dc076c9d2" => :mojave
    sha256 "5fc12dc408b61af844dcb5ad4157a2b1ad68e91aecc6c931479388d5b4b0c0a6" => :high_sierra
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
