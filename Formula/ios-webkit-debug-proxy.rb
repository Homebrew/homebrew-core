class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/v1.8.3.tar.gz"
  sha256 "21e012fd6d651777784a9d6809ad812c1ca84b4757d20f94dd2d4391c8e9d485"
  head "https://github.com/google/ios-webkit-debug-proxy.git"

  bottle do
    cellar :any
    sha256 "c16647d7595ca6e09c09a6e6d4c7399326d88b1c1da5697a2ace225730550486" => :mojave
    sha256 "30ed9c9006d712cf6b550966978006323505840fff8522449664733d72f9600b" => :high_sierra
    sha256 "deb979ca5f8df37e7323f8d0169e51f0fb4781936e15e9f7135811e1fe6f152e" => :sierra
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
