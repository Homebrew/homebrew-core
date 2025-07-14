class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "908edf4cdf47efd8c26a837e49e35c2da7f40be6f459e4a6ef1ff88de2e23153"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6177f29f3c0e9071dbde38c76472a46129ba3d6e149887af683ccaf71b98770"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "311d174692d2169f3c89bf807ea1f2ddab8fe697cb61aca2ec0949eaa469161f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a97883d25e88d132dea5b20f65e1a37d31ab845c1923a6ef82dca498da3ecc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc06a9865581339c19954ee7fe79a9239f78ae52f92e8d220c17d5833ad54c57"
    sha256 cellar: :any_skip_relocation, ventura:       "edf62e0c8db256df48543e3c83e294853aaed2981f8b0b38898dc931755dfe76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a84c4770d2d9cc91c1142618d9da8e682c637c061526d04e5cd825c5904e1557"
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
