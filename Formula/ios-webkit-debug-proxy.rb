class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/v1.8.7.tar.gz"
  sha256 "e82dcb75b262807c03f12c2eb100f184d0091b2dcada169b5faf4104937c0e6e"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/google/ios-webkit-debug-proxy.git"

  bottle do
    cellar :any
    sha256 "6de03a2d656a94b02c930dc3d2213e9399c8b9179e6257a7e2bac636e5190999" => :catalina
    sha256 "fe4c5d52840074e86516f5de37a44c89bb4419058b4f3b2023d5cfbb3f16b84a" => :mojave
    sha256 "20cab0ad99a2c2559330eb505876c9eaabc42d97709f1ad039dba2b5e54437f5" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on "openssl@1.1"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    base_port = free_port
    (testpath/"config.csv").write <<~EOS
      null:#{base_port},:#{base_port + 1}-#{base_port + 101}
    EOS

    fork do
      exec "#{bin}/ios_webkit_debug_proxy", "-c", testpath/"config.csv"
    end

    sleep(2)
    assert_match "iOS Devices:", shell_output("curl localhost:#{base_port}")
  end
end
