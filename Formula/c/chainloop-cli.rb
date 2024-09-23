class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.96.12.tar.gz"
  sha256 "1c1336e7701848acb56e82f02d5a17810d098083b69c967b7b82e8fa92f938a7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "391d1d7456fad430ed9132e2747f17622bcf4e8c365256bdad380e0f732e4b62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "391d1d7456fad430ed9132e2747f17622bcf4e8c365256bdad380e0f732e4b62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "391d1d7456fad430ed9132e2747f17622bcf4e8c365256bdad380e0f732e4b62"
    sha256 cellar: :any_skip_relocation, sonoma:        "29c8e0cd49636d799f954013a35381f6044198a9fc61fbab7211c51fb64b0745"
    sha256 cellar: :any_skip_relocation, ventura:       "4301dcf81ab49b079044ece748c266528cae1d22f498a3b402619f6e3c4f6027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16774667d581217e4edc5dc40b52448b751d1a477ab238b9af39bda82a37923a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
