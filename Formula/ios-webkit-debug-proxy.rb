class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/v1.8.5.tar.gz"
  sha256 "5d3f71609b908910249a1bcdcb20c5e94f0cbea6418dc9f1d36ec2f41bed80a7"
  revision 1
  head "https://github.com/google/ios-webkit-debug-proxy.git"

  bottle do
    cellar :any
    sha256 "1aadb8bdcb8d9f3026f20fdbae563d01d889964a94a46995ebbdf70446f3d4a7" => :mojave
    sha256 "b2ebcf8d4009ec190ca13f9fdf6dfc212b3db6cd2fe36cdc16b89054f25d1afa" => :high_sierra
    sha256 "a41fac7294b52cb9742d8cb04ed36a182b0bfabd41342529862b9896a3538a55" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on "usbmuxd"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ios_webkit_debug_proxy", "--help"
  end
end
