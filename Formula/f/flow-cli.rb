class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v1.4.0.tar.gz"
  sha256 "0f1f5c3d7f737d5426f5941ba334bf6be9460f3566eee13318776758e200de6a"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "088bdb0ae518a9564c1d3de7c8eba433dec48f14cdb0f9bec93c11926fabae94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6d491638d37a42c98b24793ccf7bc742fac43fe84cff74c17750693d7f05e69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ca13b1fdd9f457e920de2ea6e176e146e800a2977ed6b464cdd2862881b2706"
    sha256 cellar: :any_skip_relocation, ventura:        "6a60d1f1a05c87639ac89b1e16b8df97c870ac5ed1437198573bb3cb1a630077"
    sha256 cellar: :any_skip_relocation, monterey:       "71a63b627f581f10fa571cce92fcc61363019debc60821d7767ae3ff748997e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bde1236d12b67ff3e0a1282716af5943e1dbc0dc576eb85d306dfb0a6bd6b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96810775d0576d9c78b3e298105d94117c94714f87e7688fedab97f89f86534d"
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
