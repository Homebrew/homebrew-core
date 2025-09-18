class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.45.3.tar.gz"
  sha256 "18191cf85365ddd2170cd8e1ebff49d7ec5ccef52de2dbba9088e33bf851fb88"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50767eaabfe62e1e8e4ce99a02210f6fe4ff8320a19445bfadcd5ae57ff37cb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "678b18614dd4346e6df9f23f5f217d2482fe42520ff6ccc7964029b7c877d38f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4fe692f10dec8a6c7879cdb92a2c7d95f13988ccc4561472571a62e03b5af53"
    sha256 cellar: :any_skip_relocation, sonoma:        "b83e0bad93732bf3e73b06a2148e4d10ec2fd0707b248eca5561d7dbc16e87bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2768e0b89805fbc35e366faf95cb3174dee7f2b21da96dac90c70ba2079bd7a3"
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
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
