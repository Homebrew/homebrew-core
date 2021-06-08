class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.2.1.tar.gz"
  sha256 "49bdfaeaaa3f91bbb65621426e2ca3c30ed1ff66ca7a86b1f343b9838e81c7af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "276d7c1cdcc4c6b24480a81cec39f302a0fe338a9744b496e4802a43f58b57d9"
    sha256 cellar: :any_skip_relocation, catalina: "cec61aca86dffb4643598517757881e25fd23837750dcde32b5e64f7e705b3f7"
    sha256 cellar: :any_skip_relocation, mojave:   "d8d129e954ce9347a8939c44ed4c9b1be43c02f5beab1a368351d92ba5045f97"
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
