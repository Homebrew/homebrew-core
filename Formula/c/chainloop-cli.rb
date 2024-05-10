class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.86.0.tar.gz"
  sha256 "b899661efb34888d8698fdce8c84736d144f0921660bbe97bfacbe52d3f73124"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e62af53f2f7492f84cbf0f545311ef52560365d8cdc3cd751149a74474b5580b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70b58ce087da1a018eeba6bc4c575cd766e20582640fc55cf4f506aa3c5c16a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faf1f180e6303da70479228d2eab48fe9beedbd9b5376be1b65f938bbaf1aa19"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca07f0992d0e677cb144f1c4929101903b6c065d870d975917550240f5c72dc7"
    sha256 cellar: :any_skip_relocation, ventura:        "e7e73ee2c82a549b395c6493f6983528496a5cf6efcf52625c994839c7f2bf40"
    sha256 cellar: :any_skip_relocation, monterey:       "657f827825c990dcb4178491d26b2c9d2d3fa9f3fea2f7dab4847d6d2273df8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b696ffcd0f886c9299b3572a9195c6c19ab46ed5fa34e54c960277e14e6ec2b1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"chainloop", ldflags:), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
