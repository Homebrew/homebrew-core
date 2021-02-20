class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/developer/get-started/ioctl-install.html"
  url "https://github.com/iotexproject/iotex-core/archive/v1.1.3.tar.gz"
  sha256 "1a9e50a5831d9543489187944b1fc73bdaf3ae87c9cbe8f46810f25a915d0e24"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "3a4ed6686010c057740b3034deac2213f2c3dd6531be061f3f723ce71d368d70"
    sha256 cellar: :any_skip_relocation, catalina: "91ac4733539093413bf3d8bc3b4beac08589917ef84434bba5ddc61cc49a16ca"
    sha256 cellar: :any_skip_relocation, mojave:   "02c80614399fc92d2425b34b00931acd20c689d93a588a1adcb137d8b60ba807"
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
