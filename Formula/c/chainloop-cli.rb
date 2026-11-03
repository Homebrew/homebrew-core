class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.130.1.tar.gz"
  sha256 "a5c7107ed6bbf8a5bced469d037c985a8d2b2438387f0f3b6f4a24a5920ccfe8"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5e443e7b42f61e5bd60618dfb78ea8eecfb23b2b9e2ef4d539f64189f37d1bdd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5e443e7b42f61e5bd60618dfb78ea8eecfb23b2b9e2ef4d539f64189f37d1bdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5e443e7b42f61e5bd60618dfb78ea8eecfb23b2b9e2ef4d539f64189f37d1bdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9ad53e1fb8bd8e6e070ee45e4a52021a57a66992f6d75e508c5b868aecda08a0"
    sha256 cellar: :any,                 x86_64_linux:      "11cbefce2741d001f0290688825218ab477177ca065e972d997c721c16f034c7"
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
