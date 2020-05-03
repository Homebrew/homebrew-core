class Bluetoothconnector < Formula
  desc "Connect and disconnect Bluetooth devices"
  homepage "https://github.com/lapfelix/BluetoothConnector"
  url "https://github.com/lapfelix/BluetoothConnector/archive/2.0.0.tar.gz"
  sha256 "41474f185fd40602fb197e79df5cd4783ff57b92c1dfe2b8e2c4661af038ed9b"
  head "https://github.com/lapfelix/BluetoothConnector.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b49cd1726285c91d42935e0052814940a9c33a99df54ea1da2eab4c5b7411c71" => :mojave
    sha256 "b49cd1726285c91d42935e0052814940a9c33a99df54ea1da2eab4c5b7411c71" => :high_sierra
  end

  depends_on :xcode => ["11.0", :build]

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
