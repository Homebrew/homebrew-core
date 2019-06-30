class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/v1.8.5.tar.gz"
  sha256 "5d3f71609b908910249a1bcdcb20c5e94f0cbea6418dc9f1d36ec2f41bed80a7"
  head "https://github.com/google/ios-webkit-debug-proxy.git"

  bottle do
    cellar :any
    sha256 "b8058d0cc84cd94c50c1e0c66a783f5ea4328d10ef1a166dd87e6ca236e533d9" => :mojave
    sha256 "e7b603f9c7beb0d3a30cc770596ecb1d56dadfa7cea6c3b299119dfa00b868b6" => :high_sierra
    sha256 "8f25c038350c5a577589d5a91b2f7a0a2f4a6823c0e385a6cf5ec90836bf4b50" => :sierra
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
