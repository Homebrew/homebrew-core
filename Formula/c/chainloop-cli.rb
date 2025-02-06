class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.159.0.tar.gz"
  sha256 "5c3cc34580015d0c237c68f2da4131eb41d3d1ca7913a37bde9b29efe1a15ed4"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff2c9ac0b44e846af768cdbf949029d2bd4c74b63d84d88003de4fcc47cc59a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff2c9ac0b44e846af768cdbf949029d2bd4c74b63d84d88003de4fcc47cc59a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff2c9ac0b44e846af768cdbf949029d2bd4c74b63d84d88003de4fcc47cc59a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "435b65ec9047180c6c1d5faab9d2a9599336fb012ca7d05da32689e8e31d5817"
    sha256 cellar: :any_skip_relocation, ventura:       "684db3d2eccf1ebf4b7258a7521826a797938659be1b8e17cd5d1a6d3534e882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cf1126559e232f74a748a041072d0e25f71dad511751879824d6227c3e02c3e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
