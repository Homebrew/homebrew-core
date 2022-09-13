class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/v1.1.0.tar.gz"
  sha256 "26e7e0c040cd13a471a1c1c547438b4327eb97f1827352f5c77ee425d68ae877"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34cccd2bcd9271be85138f19cb68183079ca5cee441d089d3bb4522ec228731e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dae602c5e46e531bcea843cdcba68296c72984e71c283053b7c5fc4029ef32d8"
    sha256 cellar: :any_skip_relocation, monterey:       "914fb8ea657c75877c0e7e33fb76b3ff33aac9906ccb5eef0e61df262c0a7460"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0d5395c03e20649905d1317c8b29819496a762e1d1e62ea2c6c1e68ac8b75dd"
    sha256 cellar: :any_skip_relocation, catalina:       "81455f073ad844375050f3875f0b24c0cd11f73e29ea0c9c898a769534e22f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e32a6fcaddc846045bfa506c2b0a8e9d6ccbeff1a6fe31ee49b42878db0f3581"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end
