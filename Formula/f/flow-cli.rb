class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "6a3427d7b9006f33afa604ff481ca3dc471d20580ffa26ef3882a800f0086623"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73298ccf6dd8c295ced2e08ef77af32ccccac1a7e10ab1eaf118f2ff92261674"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cde2346396848458da94493c8656f6ff741fab4c3a4a011560683ab37c02355"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9862b92c45cf3b073ed27b03d6438697972a05d8052ce81e37523dba18c87b20"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7d6a489f2e7d74d461871ccdd803697abedc2d8f58a09fa72753453cbfb58bb"
    sha256 cellar: :any_skip_relocation, ventura:        "6201cd20f02c1b5d632bd9e55fb66a4fab64c03b6660f94e4ac3829466c94c2c"
    sha256 cellar: :any_skip_relocation, monterey:       "af36b0fe2b06510b873e40449241619691e8b2b006f4fa52304e5fbd6298a6f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2339e2a03dd8694496835d4b15e9d7bf2d941b5efc41cadefad1f5834faee51d"
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
