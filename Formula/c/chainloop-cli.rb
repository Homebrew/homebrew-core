class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.95.7.tar.gz"
  sha256 "01da160f3fe13e5e6feeca14edfe137bc0556bad766bd232c68e0f00e8652e58"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f5f4b17618caa2aa503889aec4ca3e86fc026bdd49c34b6e8538d2684d52169"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dafaf097419f5dc66474d90e79e62df56f2876ca51765ec741c2cd7df7dc98ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db692a11eba653550061228ec91042a966abf57c0f1a2b417867ef661f1236f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae0419a99df89a24375dc5c13d9695669ff20962ef4e99e71077232eeafdea0d"
    sha256 cellar: :any_skip_relocation, ventura:        "b67c92f1b3b3b3531835da9079b911a662447b8d86ee6c6737d6d36a70a7a83f"
    sha256 cellar: :any_skip_relocation, monterey:       "1d6ff7d2d742bb10c4aab5df95443d9ec7130142f404830e3fb83a3ce51aa65f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f83d8be40e9395d4062ef5750ff196388021bdda60ac0d3b008156865488aef6"
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
