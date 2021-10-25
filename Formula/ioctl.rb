class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.5.1.tar.gz"
  sha256 "697deba952027360105004f835560c62231e254833f984ec985f4f6762f27ea4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d849d8781b04a7012f53ae864b80536b1344acfe8d503a5be6fb60061a41035e"
    sha256 cellar: :any_skip_relocation, big_sur:       "a5622fe4327d11100d51948ec9d5d857a6e936901559b8758debf4ed6f50d40a"
    sha256 cellar: :any_skip_relocation, catalina:      "a9c59140d682284b834631b491d42d529783406dc1bf1226f82dfdd244ca0c98"
    sha256 cellar: :any_skip_relocation, mojave:        "b765bba41d70f94be0d1f81163f30b81d3a3d8f5bf8c7c385cab13795d8a663c"
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
