class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/v1.9.0.tar.gz"
  sha256 "ba9bb2feaa976ad999e9e405d8cd8794cdf3546130a79f4785235200ead3c96c"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/google/ios-webkit-debug-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "7bed3aa738aa0b55c4a923571d1cb6d7dece8c36a40c689763b6d808ca5fd096"
    sha256 cellar: :any, arm64_ventura:  "2e15e2507a76e76bac5b808e5a312dee84534081d3b61ed9b0e6cd6064de41d7"
    sha256 cellar: :any, arm64_monterey: "6e2de52a77bb737e611b61efcb6a3990daaa177f1b464e1ca9aa6bb067f6b10b"
    sha256 cellar: :any, arm64_big_sur:  "cb9b1101f02036e9fff4bd42dc85184726f579f8781ae77b5ab6f63a4e8e0318"
    sha256 cellar: :any, sonoma:         "abc303428415287a41b121c5c6525f12e6f80227ac27ed47d8069715fabcc633"
    sha256 cellar: :any, ventura:        "318c0dc88e175fea4de51f1d34c33fd28547d8cdbc13530fece81069ef3d8181"
    sha256 cellar: :any, monterey:       "0380d81a70ec66f0cac1c1c86a71dc82a3d93fbfffbba49ac5435389855dd508"
    sha256 cellar: :any, big_sur:        "07ebc21b39e195a83a93240d74432e882ca31618b4efe9805c39da194035271f"
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
