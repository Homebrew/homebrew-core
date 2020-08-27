class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/developer/get-started/ioctl-install.html"
  url "https://github.com/iotexproject/iotex-core/archive/v1.1.1.tar.gz"
  sha256 "fcff5ce4231253ebbe04e0405a36a7b89fb2d6c1b30ab0b5deac6ac6f84f9f8b"
  license "Apache-2.0"

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
