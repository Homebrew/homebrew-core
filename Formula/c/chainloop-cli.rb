class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.83.0.tar.gz"
  sha256 "6dea8a4e236e11118374a3ed84c1d55cf32c683d48adbc8c078f56857a54cb72"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf06a0674411e5434a7ea23bd7ae67eb5e49c95fd0ce6ad12793ac217372174d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4ec136e7ae659ad63a0fb6bdc6509adb38619fafd5589b7455e364c1b04ac6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8288eeea8bc419cd67daee6f6e0c26a097a37c9013177d030cd12a2b32e27b32"
    sha256 cellar: :any_skip_relocation, sonoma:        "c12c53648a3af955e155cfc0894fcc15b18b686c54e7d7ee9dcd474cfcbfa047"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dfa64b1b04ad6db8dca217a75b36d97ca8fa7d0ce03e1d7dd607d275a20a544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f65653de7a064b75dc3d3f88c5ac0751eb4164fe457e532e352fa7318e42b48"
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
