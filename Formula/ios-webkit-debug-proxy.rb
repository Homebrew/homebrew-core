class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/v1.8.3.tar.gz"
  sha256 "21e012fd6d651777784a9d6809ad812c1ca84b4757d20f94dd2d4391c8e9d485"
  head "https://github.com/google/ios-webkit-debug-proxy.git"

  bottle do
    cellar :any
    sha256 "30cf0f5605742e6e841f7d27c5ac799f3fbf42e68d448f4890397e6208e33288" => :mojave
    sha256 "721ee26c4905c9ca19780cf1686a705e705efc0e04e712eef98a3606f735f755" => :high_sierra
    sha256 "38ff31af3445474427aebbbc5a4c8138a241c8cf3fbd070c9b14553aa53b52ec" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on :macos => :lion
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
