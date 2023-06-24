class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v1.3.1.tar.gz"
  sha256 "3a994e6afc2e71b3f26b758710fdc251e7f78612e19fbce92c0f8e165bf6f1f4"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64347cc1961c131bad1ae7acee1457e3e8748f8a1e60435f37286947cab73e57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c548d0acbe67270eb61599cbdc0639b83c833d3a1ddfc5912dc4cfb6b3e8bb43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f74faf26ff9e712f36a012469ecae441e724d47ff0de3f37e0364cc52f1f904"
    sha256 cellar: :any_skip_relocation, ventura:        "6a9c9f457d49d0c569ec8fdd6592e0dd16907264e4cdc33df91f312b33b7eda9"
    sha256 cellar: :any_skip_relocation, monterey:       "07828372b4a140b8a711030570f9535b3e19008cda90342477d3a82b2b8f8a00"
    sha256 cellar: :any_skip_relocation, big_sur:        "db99884d4f31f789eeb8f13817788448698ffc31d0751bf4bb8dad3a48b0984a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f186a2abd403f9dac70d26078ee558a531420999a602f9a295551fa6bb7a1a8c"
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
