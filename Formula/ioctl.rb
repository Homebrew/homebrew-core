class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.4.0.tar.gz"
  sha256 "e7d4e98f088d4b984f993194e088c797ff4d226d59d661110d2f89b66db554b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "16aeba59da8d4f58fb5e739e54c91da7228060afc5c3f1bf6443d1951538b903"
    sha256 cellar: :any_skip_relocation, big_sur:       "5fd0ee28a21dcf37cfc3d0fbe7d3a49d0773c0569aa42b2565b3c70e0dbf40e4"
    sha256 cellar: :any_skip_relocation, catalina:      "7ace136edc0624c4434d37c1341d86c62514220f59951cec49340c48cd5425d2"
    sha256 cellar: :any_skip_relocation, mojave:        "44708a0811b00a70ab27ed80b213c5cf0bcaca90d9b6c6ad5afe4beba3b6a2d3"
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
