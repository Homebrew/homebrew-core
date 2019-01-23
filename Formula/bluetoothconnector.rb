class Bluetoothconnector < Formula
  desc "Connect and disconnect Bluetooth devices"
  homepage "https://github.com/lapfelix/BluetoothConnector"
  url "https://github.com/lapfelix/BluetoothConnector/archive/1.1.1.tar.gz"
  sha256 "8ea61b26ebab18b6ee8b8960d016d41f514d26ef9a7b4452c467017ab1859056"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c3b876a95fe14f0716239d9eadf882b40ce9d0df71080502581800231904340" => :mojave
    sha256 "282773ff899326dc1c0dfc1fa7941da80c46d314ae1b0930a68d7e3e5758a73b" => :high_sierra
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
