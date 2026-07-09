class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.103.1.tar.gz"
  sha256 "258701deea31c0bdece9462cf7c6500d02bc1a0454e74cf198b086a6046b05c2"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91df99675afbd64ed7d9a0f41b7847ad6f059505c28e5e99d72550993462e01b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91df99675afbd64ed7d9a0f41b7847ad6f059505c28e5e99d72550993462e01b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91df99675afbd64ed7d9a0f41b7847ad6f059505c28e5e99d72550993462e01b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e19e09a7533c6b3af7445e432165c44557f646d95c6e09fe49f63094046a397d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "246ce10e402c9fa9a48e44d3236b4a9473529ddd1a2f0bca55df23a3fd773178"
    sha256 cellar: :any,                 x86_64_linux:  "31f4b236c52da8b5b4457e9b1c6fca51ca3da24b51ba53b73ccb631a79cc77ce"
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
