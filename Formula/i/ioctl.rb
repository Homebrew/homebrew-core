class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "a046e08b9a99598cc73ae02825a3bb5e0e0d1f11d7f1642648adeb5b40e60140"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b9b05585588257f588dce9facece5b093910d7f1f80c7b054cdfe72bd2c8de6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a56d865369c37379e5b1f4ad6c8f5368b1649c70e8ac5ced4ceca844cb97f69b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a56da67385e213187041919e48dc0e0dbe012dc586c6c929bfd4e070b6940e69"
    sha256 cellar: :any_skip_relocation, sonoma:         "4aefb70ca83ab0a1ff473a7f63e2d829758e99c11b2020e7e4125c8f079a7402"
    sha256 cellar: :any_skip_relocation, ventura:        "50120d86bf16119b286316a6a8619bfc8531a2b499bd3c935285ac139e59ea10"
    sha256 cellar: :any_skip_relocation, monterey:       "62a0694c408884863c417ffa650646a8e35131a65a9ae1eaae3d0a1d51028d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f410dec7ed2a9561f4571cfaaa72162a1e76fa951bf884ac11e5d07329a45d57"
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
