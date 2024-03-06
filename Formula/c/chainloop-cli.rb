class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.75.2.tar.gz"
  sha256 "147e946dd6783e077dfc6ed467e7044cb931856051cccc258f195d79f1472a4a"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffebddabdee4fc7877ca23386e1332c306de66bf438869519480ee8cdb3f61e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8ebcf30287e60e039bb5903b712f7875f6632deab8531a05a7da9f9c7cae9fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8e11168d782562718655cd2c91b44371a94ab9632b85c03f4d1b70f782a2e96"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f5bdabbedbeaf2a3fc4ee50d835319131d84688fde3df5d7ec075a216d654b4"
    sha256 cellar: :any_skip_relocation, ventura:        "a9a43ba3b3c4280ec4fce5d50d3a2d7fc5319aacba7ba0f1865605c95bf425d6"
    sha256 cellar: :any_skip_relocation, monterey:       "4f8ce312e012db9262f78b18f91ba49f1ab7def8eea008f7d23ed11e1e865d0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79144f0209b19019c586a5103db97fca918f0fce847d237aee8754083e2fe884"
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
