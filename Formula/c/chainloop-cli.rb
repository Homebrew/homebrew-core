class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "3904cab56b41f8e9e7e615084a73c14f7ec262084bda704cf7cd166f4a85c415"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "921b389967562d43ddf680df2105794f6b14ef087f3b9ff90ce09b32f28bf780"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd78435bd470fdc5c93ebd3ddb9dec0bbcb1fdadd0e54aab60a6baa634eec47d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ca7a9d7e1c233ec576e62a13b2273bc7e38f934ff0e813817e22965f6833a0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b04b8f32527ab7d0cf9634d5a1be2c738b15ace3064044221dd30bbbaee3dbb"
    sha256 cellar: :any_skip_relocation, ventura:        "5694396523e9012aa0ed498cddb8a8b191cdf0e91bc1fae3ee26a2c11f20aa0b"
    sha256 cellar: :any_skip_relocation, monterey:       "cadfa62d06ee9c97ea444074bcfe3d69e356ee266016c26231f5404f2dad9b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e58058a27692a3fb353e7f981e95b0814bb1f3f536aadf90eba02e4ed91a7cb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"chainloop", ldflags: ldflags), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
