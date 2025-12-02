class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.61.0.tar.gz"
  sha256 "5828d3951950d8b315aea1415535d25b54abb61d1ab3b965470fc44e37b6e7a5"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7ba1059b552c6ed59cbb07d728772a79c8489eecd72b7d8111870278a18164c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a280a5da30403beeaa416667cf7b993e0086bfb5d5f0df1a1e42cae13d872d49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4be1f02ad45025e9be56b3275259b2b67f2891a27f59116a46689d769863da2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "65169868e7ee817646ae5994933b2e04c26eaccc851c3d46342cd61b1926cd67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67cf82c71db01e2f3276ecffc3112070d6500f61b33fe7a54d523aa0f4b5809a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff76ec1b9e341de14dfcbb451c489ecb6a8ea8e0747fa2a407db3d8340f26144"
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
    assert_match "run chainloop auth login", output
  end
end
