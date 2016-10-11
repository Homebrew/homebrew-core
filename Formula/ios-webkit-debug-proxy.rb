class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/1.7.tar.gz"
  sha256 "e4f86d926a93b25672d4337af9c3549896125c7f345bb1d98eb3dca7da12c123"

  bottle do
    cellar :any
    sha256 "ddc1f4b34f2ad2bb585aec9d3be281641f10df8e9737b4359f55cab9efc5c166" => :sierra
    sha256 "76982a9dd1b3bfb2d78cd03f93097a214d9e440df5398e66d1280671843071d3" => :el_capitan
    sha256 "22b7d35ec8b79186a6c9ed8be21d1d77d4e45ab3833c8feca68dbc0994197937" => :yosemite
    sha256 "54b86fcdc7fc1d6a3edcb80b252503b4b682603a3089e8deecfdbf532562fb27" => :mavericks
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
end
