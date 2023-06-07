class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/v1.9.0.tar.gz"
  sha256 "ba9bb2feaa976ad999e9e405d8cd8794cdf3546130a79f4785235200ead3c96c"
  license "BSD-3-Clause"
  head "https://github.com/google/ios-webkit-debug-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "8783920760b38ffec7eea45645d85fb055ff3c48483d7c1e7831c1c290c92ee4"
    sha256 cellar: :any, arm64_monterey: "ccce3a0260dd84e9dad0a39837e96c0c0c84f486b670fb8751db60089c6b490a"
    sha256 cellar: :any, arm64_big_sur:  "d4fc36ed1066af71fdb0834630f1815f4b22700548fdb7a481d9d1752545586a"
    sha256 cellar: :any, ventura:        "3d4a7c7f689dd22806bb649bb89ba947e12eb16cb036374d31159061786f76b5"
    sha256 cellar: :any, monterey:       "7ce5286b7e4e2814d154f4e1d4d0d3ba29df745035d7a4cffcc35a9a95bd7154"
    sha256 cellar: :any, big_sur:        "454295ce0a0bd3142ac16c758a8d923db079177357734ee47f717135f6864519"
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
