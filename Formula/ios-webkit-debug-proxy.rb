class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/v1.8.5.tar.gz"
  sha256 "5d3f71609b908910249a1bcdcb20c5e94f0cbea6418dc9f1d36ec2f41bed80a7"
  revision 1
  head "https://github.com/google/ios-webkit-debug-proxy.git"

  bottle do
    cellar :any
    sha256 "0a8516877b50c17ddffc7d9e80702f3221aa33ef88ca1cceb4eddeada198d37f" => :mojave
    sha256 "a84067180c1c839f8d17d1d530f46a7c4ea753b5acf96005960c0ecb147512dd" => :high_sierra
    sha256 "4d8d1545d4555b6787d42037e3cf84cf5d046dff82f52a850b85ba8cab955867" => :sierra
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
