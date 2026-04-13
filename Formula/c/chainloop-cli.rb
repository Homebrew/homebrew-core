class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.90.0.tar.gz"
  sha256 "57f6a714c2a33394bc278760859d599d378e395735f2b689dd1339524a65c4a5"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec1be2c6d5138ec53c1fc24cea5d272dc895745b2705fe137f282e2c21256976"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90cf6997c6f0bc91f1a2699247689fb48b991cd95d7a9ee288d0aa4ada6bc510"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eab886a5f263b66ff003be8c5cc0b30633ecd2db02a1a36688dcaedba77e2f5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "540de7a3e4faadc919ff2b096a235f2e9c3df516145a7cb56aee471a99aa5acd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f0b47f620b20d947c880aaadfa2558efd6b6cf0ac62a0fbc1c7e4cecfa417b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "800a0a314057953a6fab65cec57427e314405af31a5a1b2ecd8b2ef68c11cd09"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
