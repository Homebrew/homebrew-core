class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.10.0.tar.gz"
  sha256 "1280e0b75318b13a3dc34d76e949c024eebf8160d6b302a9517d618e44eec4fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c61ea050223a3431558c20c7a9570f8e6cf1e3b16c3ba08343eab5a0d71b5ac5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e99e86b708ced8ea4aed6a7488e166fef7adb1ab4ddcdae647191fca621fb306"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bea11fb4b013d70fa3b7819b34726f32582900f172a54c63b284f6c19ffeae4"
    sha256 cellar: :any_skip_relocation, ventura:        "dc130ff539eb5a3327370d1d08373696a62b458af788ba8ac437c5b282cee5c2"
    sha256 cellar: :any_skip_relocation, monterey:       "fc0f99b166a42d963881c52960e2f37c67e1085114f4da9101afc21a6da05241"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d6ea29ebaa75ee135a45159f95b51c9bf22ec74066b3d8ff373743e405d34b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9843006905c3c29ca5cd74567c2ebc7b7a3d7cff944768fa3d09f709e59c4ec1"
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
