class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.60.0.tar.gz"
  sha256 "6acb2a2c03768713a024e28e34173a67c64acbdceacb6288bfb4f1db19a34fa4"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba94d70d31c4f38d011145f6a681c4db323de12734d3719e774362018f8fad3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5eb35e8a292d522b57317c43ad785a46619099a211f27f9670183ef27deccbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d05b6209d6be7cfa54114428c925cb39376585515bddfc6346559d5adf97c35d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f2821aa549433cbdfc197ea3f332206d569d15a3a8c4f33a003cdc42281b03f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6552585ce28604500f42e44834333e8e6ab935145ad08d613eafc35426645ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fafcabf7a8d15831e20f30c626ac4b7f11f9909ef00d87b4bae46ef680f3658d"
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
