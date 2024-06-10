class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.91.1.tar.gz"
  sha256 "3d7de5ac82dbf78a34052d9466562f7a3e1b1f5b6cdd8fefbf33fb4fa8b2ed85"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9147b4f2e4810e6d3255f3d791086601896d95960e14d9b0986ea60e4c0baa5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "889ddb2570d4d0029b7bf476e2113193ee7c7542c6f615537d05e6a16c23b7d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb6236dcdbdfd674889ac2d89772e67e245525a7e844b19dacfb052bbfdd8f50"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc99e9680ed226b390410ae6360e25c2e7f9db9efb6691a0ac23cde55e24219a"
    sha256 cellar: :any_skip_relocation, ventura:        "e71ed2d58f16cec08ad9ec655ba76ca1567551ceff359eeb32e9d1d45ec2ad95"
    sha256 cellar: :any_skip_relocation, monterey:       "a23f5a79292b9035b63af426415009449897a355235bdea326c8e9bec841d5fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "395391440c245a9d4889dafd2b3ff89ba404f3a7434ae3edade8637b253fa741"
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
