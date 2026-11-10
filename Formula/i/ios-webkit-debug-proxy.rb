class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "799477f40f5429a8355641a80f4ba6f415cfc8b3af6a86ba4fd448cdf9be30a1"
  license "BSD-3-Clause"
  head "https://github.com/google/ios-webkit-debug-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8319f0eacfb26bc45753c397eb037a6e0659c5b03ec732a76a042b39d183916e"
    sha256 cellar: :any, arm64_tahoe:       "01d5b391d3ae4280d072849ba8d75cf2875ef2844f9925823a63d0b6ad673658"
    sha256 cellar: :any, arm64_sequoia:     "5b1094c9c2ea6301ddf76bf9829843455eb5bbaf39f9cfed4bc1fefd549f5d36"
    sha256 cellar: :any, arm64_linux:       "196a65e5b8c6be692b9d76add2cc11f8de829a7583c40580919bb3b4b3ae3ce9"
    sha256 cellar: :any, x86_64_linux:      "988cc22187d15d0e407643d80f1e397a6c145cb7403f18a689f51d6e2a29d75b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on "libusbmuxd"
  depends_on "openssl@4"

  allow_network_access! :test

  def install
    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ios_webkit_debug_proxy --version")

    base_port = free_port
    (testpath/"config.csv").write <<~CSV
      null:#{base_port},:#{base_port + 1}-#{base_port + 101}
    CSV

    output_log = testpath/"output.log"
    pid = spawn "#{bin}/ios_webkit_debug_proxy", "-c", testpath/"config.csv", [:out, :err] => output_log.to_s
    sleep 2
    # Setup fails in both macOS sandbox and Linux where we don't have usbmuxd daemon
    assert_match "No device found, is it plugged in?", output_log.read
  ensure
    if pid
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
