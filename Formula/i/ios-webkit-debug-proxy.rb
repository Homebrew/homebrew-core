class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "768f101612bf5d2507957f10a8e34e98675ea8fe3c63b8ed78772f8abd103fbf"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/google/ios-webkit-debug-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c59efa369c0ea7dd80c9164d1001ef0e9fedb460f18b789f8a8aac483319374d"
    sha256 cellar: :any, arm64_tahoe:       "4feede5d70f45f64cdc6c02228498bd9527584e514e082ebe4920fac06bd7ba4"
    sha256 cellar: :any, arm64_sequoia:     "f570a1e916f859dca6ea38678d6120b0a94fc3074511e6a6954efee4404cafb7"
    sha256 cellar: :any, arm64_linux:       "6eed93a15a8546a12746a4cda3444d94d302bebca0660469c8a659c22931aa16"
    sha256 cellar: :any, x86_64_linux:      "2d258f272531b46e2ee4bd27f560d706ec8f3a3e0aa5549feef1a1f23a906e06"
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
