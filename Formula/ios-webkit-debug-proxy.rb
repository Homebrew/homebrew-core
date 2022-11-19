class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/v1.8.8.tar.gz"
  sha256 "5b743276f7fbcd145e6212e892867304c5e49e7c75c0f4a331ec6deb6a8d5b3e"
  license "BSD-3-Clause"
  head "https://github.com/google/ios-webkit-debug-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "011c8eb6f8b60b90ec7a23c4d5cdfe60b24079e5522fd80341e1083e4e9fe30b"
    sha256 cellar: :any, arm64_monterey: "6c36002c9d2488188b33d7f89c49b5dea290be833a7f2785b45213eff93c183b"
    sha256 cellar: :any, arm64_big_sur:  "eb231061aab2df9284d4160f89567803399b86e3c58b95643db03e429ffdc05e"
    sha256 cellar: :any, ventura:        "3cd4cf9948f66e2609071bc915b3f2f0eaeeb2cf54742b7e619dc1debc89a474"
    sha256 cellar: :any, monterey:       "6e2190f23432e24dca8d7ccbaac86ff638a03f070b6bb5528a589a70aa5493fa"
    sha256 cellar: :any, big_sur:        "0386ea5f531d49b175e460381c5f76c8696539c91225b1611d98665dba8d4685"
    sha256 cellar: :any, catalina:       "c46bfdadb61495298c52d4d771d49fc0596ed8e5f1ec28cea8a9b57c77a035e8"
    sha256 cellar: :any, mojave:         "890859443600c9a1bd40f0453a81948714b1b18be558f3991bbd8d6257274f15"
    sha256 cellar: :any, high_sierra:    "c0111ff5ffe3e9146e7589d9e009f8b1907974bf9d23004a3611412e64b671f0"
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
