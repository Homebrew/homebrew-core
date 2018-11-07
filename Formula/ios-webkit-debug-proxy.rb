class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/v1.8.2.tar.gz"
  sha256 "1d80a858343539fbb18bf7031df4a032c63792db3e0ec0fa37e1f6cc254e1f6d"
  head "https://github.com/google/ios-webkit-debug-proxy.git"

  bottle do
    cellar :any
    sha256 "70c199d2c1cd8b831c5a2f560fcba485bf6e387ca872255d60b66bd58bf8ea8d" => :mojave
    sha256 "58b7d880eba192e4d5a6c5f780d5ce9280f3770a2d4513001509a25f50192225" => :high_sierra
    sha256 "5ea7acec6111ee42b280031217c6975b610ce41fde4dce1f58c5667c2051dce4" => :sierra
    sha256 "7358c4272d5e3f924c6d9849bef1f8f7cc9f570bba4eb5ef66f34aff32ecf7ee" => :el_capitan
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
