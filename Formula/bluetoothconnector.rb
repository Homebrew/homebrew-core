class Bluetoothconnector < Formula
  desc "Connect and disconnect Bluetooth devices"
  homepage "https://github.com/lapfelix/BluetoothConnector"
  url "https://github.com/lapfelix/BluetoothConnector/archive/1.2.0.tar.gz"
  sha256 "63cf474670041127effbeec8b84f9b84421f7cae74fb2908d6c10c2b331cb4be"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fac038a2fda3fdb144fb764166eeda3b31799caf1ce8e44a8f77bd5881daf1e" => :mojave
    sha256 "5fac038a2fda3fdb144fb764166eeda3b31799caf1ce8e44a8f77bd5881daf1e" => :high_sierra
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
