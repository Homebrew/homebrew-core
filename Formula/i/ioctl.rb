class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "78f16740c03126fa31e0815e55d094a97eb8760bef4e0b3d228a769bcf9ce005"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "368f66672ee44b9dd7be0b0011ac7658a781295a4a044a4a0f0e97dfc6508741"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b33fbb173f06641e40ab8718f8e37f4265ce246f8184c8844d97cff36fb42776"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc4102369cedb779574eed0a260ee469b5efde98392a2366c3d399d0ca3a5539"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d6b23e83776e3b24671cecea5180137a2a6703695cc51bb07234b79911e8b8c"
    sha256 cellar: :any_skip_relocation, ventura:       "218132a5c7e7d117f98893f5e6b2aa6e648eb78301c769f4a3fc58a024f00190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed876bfc52d251ce54b7232ce16d86e4631297400b2fe360e7e41b3989b143fe"
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
