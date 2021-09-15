class Bluetoothconnector < Formula
  desc "Connect and disconnect Bluetooth devices"
  homepage "https://github.com/lapfelix/BluetoothConnector"
  url "https://github.com/lapfelix/BluetoothConnector/archive/2.0.0.tar.gz"
  sha256 "41474f185fd40602fb197e79df5cd4783ff57b92c1dfe2b8e2c4661af038ed9b"
  license "MIT"
  head "https://github.com/lapfelix/BluetoothConnector.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b37f1ec5f2a36af25b4156b5d5abe9a43e7e541a6353075798e8daf523312deb"
    sha256 cellar: :any_skip_relocation, big_sur:       "5b1be2b35a5d442e3874c82ebe2c37ff5ac22478d561cf28effc8110475f3bc4"
    sha256 cellar: :any_skip_relocation, catalina:      "38d8b5c89fd8fee4a746eadaceb399d5b7e1148db2cee896381b6e093aef56e3"
    sha256 cellar: :any_skip_relocation, mojave:        "1a0c1e83b5640a35c48ba982f1b7cf5b1bebdda6fd4957368262c3e001c740e3"
  end

  depends_on xcode: ["11.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--static-swift-stdlib"
    bin.install ".build/release/BluetoothConnector"
  end

  test do
    shell_output("#{bin}/BluetoothConnector", 64)
    output_fail = shell_output("#{bin}/BluetoothConnector --connect 00-00-00-00-00-00", 252)
    assert_equal "Not paired to device\n", output_fail
  end
end
