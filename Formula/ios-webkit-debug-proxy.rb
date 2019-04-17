class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/v1.8.4.tar.gz"
  sha256 "4e919a4d3dae329e3b4db7bfb2bd1b22c938fa86d59acaa6e99ef4eb65793dae"
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
