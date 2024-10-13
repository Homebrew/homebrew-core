class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.96.17.tar.gz"
  sha256 "a6a6bed82363f3573365d0568771e2fe6ba0232044248f5bea78bb237c49e230"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61ac795ecae447649bf68b2be46a2c2b4f83ce55f77e1d779ea99e9b5307fe22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61ac795ecae447649bf68b2be46a2c2b4f83ce55f77e1d779ea99e9b5307fe22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61ac795ecae447649bf68b2be46a2c2b4f83ce55f77e1d779ea99e9b5307fe22"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bc4a10bda54fde6280393ed7096865505812d632020afa92df25145455d3aef"
    sha256 cellar: :any_skip_relocation, ventura:       "f287eb14ad8809abc4e704318f2791acaa120c6780524831aadccf3e788fcdd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4adf97a258d0984dbb2504f08608d243a21a4c0129b0d22d12d4be4116847e0a"
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
