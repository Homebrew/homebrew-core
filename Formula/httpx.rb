class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://projectdiscovery.io/open-source"
  url "https://github.com/projectdiscovery/httpx/archive/v1.0.3.tar.gz"
  sha256 "e543165b27078260e661752d20531d877327be2c25eb02dacf1ecb470769daf7"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "627292b7184c6614a5f5db76a2116ca091eec99add8d4e646c64e2693ed20817"
    sha256 cellar: :any_skip_relocation, big_sur:       "39a623a558428ee6c300a1823530c3f690adc90b2fb15f85707d69adb56b91b2"
    sha256 cellar: :any_skip_relocation, catalina:      "5f1dc3e98b302dacec15f0d4eba3c23c94d84c7c8bc9ff02b5b18cd2d4497223"
    sha256 cellar: :any_skip_relocation, mojave:        "c406f1b2496acca89b00c312646be317c7f44cbf0108ba97ed8b0eb96d9cba17"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/httpx"
  end

  test do
    output = JSON.parse(pipe_output("#{bin}/httpx -silent -status-code -title -json", "example.org"))
    assert_equal 200, output["status-code"]
    assert_equal "Example Domain", output["title"]
  end
end
