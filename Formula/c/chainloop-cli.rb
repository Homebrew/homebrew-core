class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.77.2.tar.gz"
  sha256 "6972f663360ab2824dfe67eecc91e94bd9c43e1c5daf4ef2e16238f455b16c4e"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2b568252a8f95361366cbaac21521f422513e7572460518837d4a1e4b3211a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f7be2238d40a6e5ded56bbbaa1221c700e646ef3c759ccf091d68056361e2dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4efd81777a7b0d07d41baa282706756de1a8d9d48f609387435991e88d0d6a18"
    sha256 cellar: :any_skip_relocation, sonoma:        "37d960c98f23007eddaea5a6bc7d3db49afb624f1a1a2bb473e23c565d0d5cba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93d11fd2c3682288e1f697d81dbea67cf75f31695437b4c18591edd998a2aa30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a111add799a1213829caca8c9174c4ec817559b10e5e7f2150e981632684787c"
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
    assert_match "run chainloop auth login", output
  end
end
