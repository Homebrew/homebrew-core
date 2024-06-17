class Bluetoothconnector < Formula
  desc "Connect and disconnect Bluetooth devices"
  homepage "https://github.com/lapfelix/BluetoothConnector"
  url "https://github.com/lapfelix/BluetoothConnector/archive/refs/tags/2.1.0.tar.gz"
  sha256 "cbb192e5f94da27408bd8306a25e11bbffd643d916f6a03d532f83a229281f77"
  license "MIT"
  head "https://github.com/lapfelix/BluetoothConnector.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f1e8d18ce7e2ee41a70c1a8d952a91404e4701725075e56f87bb063416880b0"
    sha256 cellar: :any_skip_relocation, ventura:       "360733d6b564009fa2fde910ab9fd67baddd172e2a3763fda858db7ce0626eb4"
  end

  depends_on xcode: ["15.0", :build]
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
