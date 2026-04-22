class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.94.1.tar.gz"
  sha256 "faf953af5cd931163bcd0ac130e1fa5a6d3c85dc9c89a2120081fe27217b66da"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38c71f20e44387f3fd1181753ae49a2c778002ef0ed158c27818e381e13a652f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48ea580f97fab8dd7bde976a3ac870aa2d57a4ecb7e31e4df1f17fdc9d1243c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a9d9b1cb60162cae7c6e09db7aa942bf10be08b8153027a3e8a2c2de89d14f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dc56ce5aa3b5e2138f1199bcd96a3855d23129ad54dca14e7a322fc978d3ca8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e873bd9b99956c9fd6d5094ca699f9faa869b5bec5dc9b782bc26c1078fab3ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ef8fa0dad8c1cb463c87cb7291880d9d2a616cde466187fe29aaa2789bfb565"
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
