class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.2.1.tar.gz"
  sha256 "49bdfaeaaa3f91bbb65621426e2ca3c30ed1ff66ca7a86b1f343b9838e81c7af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ae24dcd3719f73ed24dff3911ac81607751e1ce64372aa9a03ce6090655dbec1"
    sha256 cellar: :any_skip_relocation, big_sur:       "09393fc2f50e10eafc6e920df4240969b1981144a4fcf02590d998618c953ba3"
    sha256 cellar: :any_skip_relocation, catalina:      "30d69bf70e554d0dbb14c9f6904fd4656b630887f9a4223362e5b76606c5a0a5"
    sha256 cellar: :any_skip_relocation, mojave:        "a48742edbafe448cad99ec91fbea4dab0284f62270af48bad8bb6e5144fe6af6"
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
