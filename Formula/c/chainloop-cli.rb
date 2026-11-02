class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.130.0.tar.gz"
  sha256 "4a72eae759dfb02a4afca1dafc107ca2cc7d2ad7d023ec2f1a84c56a61e2b292"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "79e8c050294970d507d18d7f55c8a60ce1ca35fb9d4c5a1e8f59e39a770aee7d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "79e8c050294970d507d18d7f55c8a60ce1ca35fb9d4c5a1e8f59e39a770aee7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "79e8c050294970d507d18d7f55c8a60ce1ca35fb9d4c5a1e8f59e39a770aee7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "51b8ecccfbfd597027ce7abb101e67df2bc0b55a3bd0979cd9f104b456f6c2b6"
    sha256 cellar: :any,                 x86_64_linux:      "27668b45a88af83bf95bcca7368ac1f334d367501514f9171ab97005074e5b9b"
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
