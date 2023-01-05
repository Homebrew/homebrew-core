class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.9.1.tar.gz"
  sha256 "c9cd702e773079b37f642291a249e43eb912b8fd620a4bb79c8bc0caf22ef8a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc88edd82985dcad2ef96718b62ddddb0abfea7a0c31d6e6a3948c86d9c6d6d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19921f5dfe21bbcc7afaadce2398f8d2fd84a1d60742eb9c86d84e4642dd0dec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0dcef7f8e1f9ae1ebbb296f049c0dbfc4bc2b1974cdcc5142e6a8a492e9b2364"
    sha256 cellar: :any_skip_relocation, ventura:        "1039fc52e71c027d5c9a56d25b40a528c1903e6239657b5d5726b9cb87459d1e"
    sha256 cellar: :any_skip_relocation, monterey:       "d32d3b8894873e78a22c80e60405b4d5ee36068ea682448f8331fa11114b28c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8eec8611ae2c9807e5e76070689dfdd2e0f675635b2f469362fb2cfa565a8710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "933c0919051e13cf074db82c8661fa053935eeabb2ff4a9ead51a67f398c9c41"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "bin/ioctl"
  end

  test do
    output = shell_output "#{bin}/ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end
