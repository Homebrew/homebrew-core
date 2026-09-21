class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.110.0.tar.gz"
  sha256 "b3783ae121588b21026949ef7531abacf277aa54763a180b3a19a83ea03329d5"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e9bd8f9eaca4e537995df68903fe11d87ceb3069e43a7f9b487fdabb4fc2ba1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e9bd8f9eaca4e537995df68903fe11d87ceb3069e43a7f9b487fdabb4fc2ba1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e9bd8f9eaca4e537995df68903fe11d87ceb3069e43a7f9b487fdabb4fc2ba1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3078481b1def833ac3e5c089c5522c74d8feb16580bfcbe0daef50f3a4d8079d"
    sha256 cellar: :any,                 x86_64_linux:      "bd5b79557ef630b3e598ac04a467dc6e648c1eaf43d734bc6f0f582810d6e854"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end
