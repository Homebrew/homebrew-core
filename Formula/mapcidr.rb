class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/v0.0.7.tar.gz"
  sha256 "486194fff1dad4fd5384a8a860277a3b8fad2f89a32f8a5b9db94e1d9b71a25f"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b68929f41f451e75384cf189b7a8d3fe0538229e2895c45a38327a701be4f23f"
    sha256 cellar: :any_skip_relocation, big_sur:       "0b07fd6dcc2c3299d06eac557f7fcea37bdf4a70db8bfc236c7552877b588476"
    sha256 cellar: :any_skip_relocation, catalina:      "e4e8bfcfd4725b2dd469d091fc0ec0c8ae5f31d678fe194e6726e35974290b79"
    sha256 cellar: :any_skip_relocation, mojave:        "2fc496dae5bc671e9a9998b505402578ed01996ce5d06fc40b2e432e265db402"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/mapcidr"
  end

  test do
    expected = "192.168.0.0/18\n192.168.64.0/18\n192.168.128.0/18\n192.168.192.0/18\n"
    output = shell_output("#{bin}/mapcidr -cidr 192.168.1.0/16 -sbh 16384 -silent")
    assert_equal expected, output
  end
end
