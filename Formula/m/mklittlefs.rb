class Mklittlefs < Formula
  desc "Creates LittleFS images for ESP8266, ESP32, Pico RP2040, and RP2350"
  homepage "https://github.com/earlephilhower/mklittlefs"
  url "https://github.com/earlephilhower/mklittlefs/releases/download/4.1.0/mklittlefs-source.zip"
  sha256 "4fa5565e2e9185898182557e25860f0fe5536f8133ef0247574105a75b5ae4d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebd5f7c2ba836785f2a85f02288e6b3cefdcac40f2e0c4086a291ec1f9b06e67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbb829ab8e9c3c40a518155aabc2d05808689225bb7177e31ee3ad2b80a2bc7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2afd18134810381f7cc7071cc2d57742e3f0903ac0043bfb1d87d54fdc673567"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48862fcd19df8ee2370233baa3ea48a92c27ad25dc5a3f8fc8c0aa404b4cf81d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c49d44f1d0ccd0ae7597dadf8a3c40e932cc5d775135d450fdb8df8a6d173c3"
    sha256 cellar: :any_skip_relocation, ventura:       "69a5cc92966e36ce10c658fc2b5e1e1d7f8e99a2cb727e5b2bc7eaa9f59ef710"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "718c5352d9f335d60515c74268ebbc2cbbb879a82e4063893418fedbf9601a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f08d3944b06a3190264af01ab13388745ebd1783419c4637cf248d1590f886a8"
  end

  def install
    system "make", "BUILD_CONFIG_NAME=-#{version}"
    bin.install "mklittlefs"
  end

  test do
    mkdir (testpath/"data")
    (testpath/"data/hello.txt").write("Hello, World!")
    (testpath/"data/Poetry.txt").write("Had we but world enough, and time...")
    system(bin/"mklittlefs", "-s", "1048576", "-c", testpath/"data", testpath/"out.img")
    system(bin/"mklittlefs", "-u", testpath/"out", testpath/"out.img")
    system("diff", "-r", testpath/"data", testpath/"out")
  end
end
