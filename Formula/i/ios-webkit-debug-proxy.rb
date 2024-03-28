class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "ba9bb2feaa976ad999e9e405d8cd8794cdf3546130a79f4785235200ead3c96c"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/google/ios-webkit-debug-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "8dc0f73b25236a393fb22ab7270c01e68f5c81b427c585d4db9dee46eb174175"
    sha256 cellar: :any, arm64_ventura:  "0f63f9da6972e048bb58c4f9ba0d0f3f398cc24225d61f29ddf6115e9648c971"
    sha256 cellar: :any, arm64_monterey: "7653d218ca09eabd015e45906349343ba592a8922754955af5ffacea2b60e10b"
    sha256 cellar: :any, sonoma:         "5d57060e448a2a42623057be6b7b0589ae43350edccd0382e6cbc373c66f412f"
    sha256 cellar: :any, ventura:        "c50a7c3caff3cf42f6891360d1bb483605e9c03f4fa96dcc62a7bcc9968f9ea1"
    sha256 cellar: :any, monterey:       "0b78423dfa30ed941450cfb746e71f710d375d5c75ed5ccd1cf87ec8c508adbd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on "openssl@3"

  # Patch ios_webkit_debug_proxy to work with libplist 2.3.0
  # Remove this once ios_webkit_debug_proxy gets a new release.
  patch do
    url "https://github.com/google/ios-webkit-debug-proxy/commit/94e4625ea648ece730d33d13224881ab06ad0fce.patch?full_index=1"
    sha256 "39e7c648f1ecc96368caa469bd9aa0a552a272d72fafc937210f10d0894551e6"
  end

  def install
    system "./autogen.sh", *std_configure_args
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
