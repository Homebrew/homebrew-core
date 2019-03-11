class Bluetoothconnector < Formula
  desc "Connect and disconnect Bluetooth devices"
  homepage "https://github.com/lapfelix/BluetoothConnector"
  url "https://github.com/lapfelix/BluetoothConnector/archive/1.3.0.tar.gz"
  sha256 "66b94a154e25c867bbdad50e643980a475a63af935900b539e7c48ed0fb1edd7"

  bottle do
    cellar :any_skip_relocation
    sha256 "b49cd1726285c91d42935e0052814940a9c33a99df54ea1da2eab4c5b7411c71" => :mojave
    sha256 "b49cd1726285c91d42935e0052814940a9c33a99df54ea1da2eab4c5b7411c71" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc", "-static-stdlib"
    bin.install ".build/release/BluetoothConnector"
  end

  test do
    output = shell_output("#{bin}/BluetoothConnector")
    assert_match "Usage: BluetoothConnector", output
    assert_match "Get the MAC address from the list below", output

    output_fail = shell_output("#{bin}/BluetoothConnector --connect 00-00-00-00-00-00", 252)
    assert_equal "Not paired to device\n", output_fail
  end
end
