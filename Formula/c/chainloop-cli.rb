class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.102.2.tar.gz"
  sha256 "9d87da59f790eb175c01d91f8b4135de773a22780b02fa70c10cfcc4ee831da0"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f87e118c6f3d2bfd6aa67fa45add816f9f10fd24ffe0f9fb05869939aeed77b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f87e118c6f3d2bfd6aa67fa45add816f9f10fd24ffe0f9fb05869939aeed77b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f87e118c6f3d2bfd6aa67fa45add816f9f10fd24ffe0f9fb05869939aeed77b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8ee6499bbf912f2645c361f9ab01c8011a9c5fdcd3029040e0e27e287e58f7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cf2d956cb9a498eaf686690b0d4989951f8337c25b091fb51c3dc3851fd8324"
    sha256 cellar: :any,                 x86_64_linux:  "4f3b9bafa3ed65184269537847d69ae207274ccc8e2829831e32583adafc0c75"
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
