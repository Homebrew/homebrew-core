class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/1.8.tar.gz"
  sha256 "5a5ba157e76d984978f3f3aa22617b0c3c730d15e1a4d23a77c12e4a581189af"

  head "https://github.com/google/ios-webkit-debug-proxy.git"

  bottle do
    cellar :any
    sha256 "4bcf8b1cf86f78454c9df257fa2a617636743f0863061c22585196e26b9d45ee" => :sierra
    sha256 "25f05f5d10255ea544e74172646edeeaeb524b305d1db7a63bdb8352eb5fe375" => :el_capitan
    sha256 "898cb683c00405fca5cbdf02b1af1bd9bb34badcfe19329eebd7d29d52e54e88" => :yosemite
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
