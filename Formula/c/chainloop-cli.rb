class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.126.0.tar.gz"
  sha256 "c36dc824812684a7c73095fd2ad253d4bfa685cf7845f1746127a8cd8713cde5"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f5a5e388e5b79506a6c3468bdc1bc3f16c06b4ba788b48525e87c0762f84952"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f5a5e388e5b79506a6c3468bdc1bc3f16c06b4ba788b48525e87c0762f84952"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2f5a5e388e5b79506a6c3468bdc1bc3f16c06b4ba788b48525e87c0762f84952"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2f369694ada605132af1fad00c719fe2504ead2001c8bb668f7b7fbe0c427d6f"
    sha256 cellar: :any,                 x86_64_linux:      "b5b6a209a4edf1065ff7e52bc3fb9e767b71f590a6a961d7135b97082cc04cae"
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
