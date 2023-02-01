class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.45.1.tar.gz"
  sha256 "80d10f426bda69ce2a1e06282b60879e9118a643df40598cfb92458cc1b981f5"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93c8f52379815b507b46d1bd3b3acb9cb263b0e9d505aebc853d7c02af8acb51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f782541c6f9c3e93e7ee7753407b2d8b0bbffb6601abb2c3092d3f6e111474e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d769c97d835decb4a29fba33e5773363646c23935da80a7842551d576de1e161"
    sha256 cellar: :any_skip_relocation, ventura:        "de27b00adcf8fb31bab254811f170201aef579b46572afed355ffa0a53970e07"
    sha256 cellar: :any_skip_relocation, monterey:       "fc7fca1a95db684aec1fc46b347a6a13863a7438080e90c3aff52f3bc285d6e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4397304d7f5dd573779e5997c710742f1fd11eb7e61775cfe4764f5d30906c8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a29ef8dec7cebcaed1f2399d1bac4de99bf3f965ba320ce852044bc8e732f64"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end
