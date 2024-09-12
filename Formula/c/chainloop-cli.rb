class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.96.8.tar.gz"
  sha256 "f567e9084df528376979218a712f46dd5b3860d152840e46039102671c2bd3e7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b9689b0cc00d7f32328513a53f2047be1ab4e4b4c4c6d96648cf2597b4dd792f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9689b0cc00d7f32328513a53f2047be1ab4e4b4c4c6d96648cf2597b4dd792f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9689b0cc00d7f32328513a53f2047be1ab4e4b4c4c6d96648cf2597b4dd792f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9689b0cc00d7f32328513a53f2047be1ab4e4b4c4c6d96648cf2597b4dd792f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9b434cbf11c386b80e0b068eebc4ddd404ddf62d64146e45096a8610f544a3c"
    sha256 cellar: :any_skip_relocation, ventura:        "d99d62fb826639125858907316248e4d8738fad22eb21bdcab0eac5fd9efcfaa"
    sha256 cellar: :any_skip_relocation, monterey:       "251d83a47f1166d47e5d558b607c94ce57c8c25db82bf46ae64b52691833c1c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f70bb7a16be334fb697fd1b347ad88fc754dabec0d757f287d36ee6277eafcf"
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
