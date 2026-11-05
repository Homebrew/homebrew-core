class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.131.0.tar.gz"
  sha256 "08ff9444fc105f1bfd48798c8d95d5cd4ce3d83c85fea2b96b862d8573167930"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84e18d61504c073ee5a8a85cfed8948104083e04b75a09538c6a353bc1fa488c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "84e18d61504c073ee5a8a85cfed8948104083e04b75a09538c6a353bc1fa488c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "84e18d61504c073ee5a8a85cfed8948104083e04b75a09538c6a353bc1fa488c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "837d15b0d3a66f1a0fbf027d2f7ad5a1ed141959ff08c808127b1a89425e5377"
    sha256 cellar: :any,                 x86_64_linux:      "cfb6ea2e89be22a68fe6c3a343cad1638b160072909ad39c7784467df4b9b711"
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
