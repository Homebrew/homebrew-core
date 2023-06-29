class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/v1.9.0.tar.gz"
  sha256 "ba9bb2feaa976ad999e9e405d8cd8794cdf3546130a79f4785235200ead3c96c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/google/ios-webkit-debug-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "98a52dee813f9b7cc3bb923f01229d5b11641e18562f22ef52e96e2b248bbb6b"
    sha256 cellar: :any, arm64_monterey: "5268a6ef7b32c2cd9d88e35e9e5667a7127258dd23c22a824e74bd4487e686fb"
    sha256 cellar: :any, arm64_big_sur:  "3d693f91e25d8b165037afcbc36e14d8d54c8317bd01c770e5077a0ea4a0e72d"
    sha256 cellar: :any, ventura:        "777efb32172aa98ef7cde6fd34107cd7fb42f132e12c8595bc2d5ad1c674e217"
    sha256 cellar: :any, monterey:       "e17aec779a16ba66f75eb9bbbc76db078192ee15b5f87490e2ccfc54f699d4c8"
    sha256 cellar: :any, big_sur:        "df411040e0e3babe6a487de5930b3ed7387610d1673ee42679780a34f72f3557"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on "openssl@3"

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
