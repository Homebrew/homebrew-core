class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.135.1.tar.gz"
  sha256 "d55bfb23442a746f3758e5ab1479fa53b8e01a830bebee861fd805f00fab0857"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8335e5ac303134e4d8e13a803a3ae3730085880c25cc143047199cceeba5b168"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8335e5ac303134e4d8e13a803a3ae3730085880c25cc143047199cceeba5b168"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8335e5ac303134e4d8e13a803a3ae3730085880c25cc143047199cceeba5b168"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3ce0d107bfada1a1c8bd982b7891150cb9854e6e702ba80bcc51cdd9b3264b91"
    sha256 cellar: :any,                 x86_64_linux:      "92c87d1f2115785f8a4f23b908ab4069e4c2a6510e6865edef169dc2e64c988b"
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
