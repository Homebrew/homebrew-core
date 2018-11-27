class Bluetoothconnector < Formula
  desc "Simple CLI to connect/disconnect Bluetooth devices"
  homepage "https://github.com/lapfelix/BluetoothConnector"
  url "https://github.com/lapfelix/BluetoothConnector/archive/1.1.1.tar.gz"
  sha256 "103a8a61f3a08eab0e2853cf4f3a44e6983eade2f0e4fb9a6e1b56b1aedc1528"

  depends_on :xcode => ["10.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc", "-static-stdlib"
    bin.install ".build/release/BluetoothConnector"
  end

  test do
    system "#{bin}/BluetoothConnector"
  end
end
