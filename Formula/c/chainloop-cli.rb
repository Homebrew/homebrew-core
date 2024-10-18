class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.96.23.tar.gz"
  sha256 "c772eff7067b42f962fb9a350e641f9471b594ec8d98d37ec38f0e6a72384121"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "118828b83cdc52c7a93baa81f002b1f892cb1849b7cddf8b5b721420a291bb8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "118828b83cdc52c7a93baa81f002b1f892cb1849b7cddf8b5b721420a291bb8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "118828b83cdc52c7a93baa81f002b1f892cb1849b7cddf8b5b721420a291bb8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "441a47b51cade29fff436f3a3fa5c34ac75b4a3367522f192bc375f976138643"
    sha256 cellar: :any_skip_relocation, ventura:       "88d5a3a6e1d4c8cb3b73a937e10262ba0970fd48c0d0a88fd4e5454d8de83d32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5578b3013e029653972102c5b5af818327c509f6524eaef910ebb0ff5b928522"
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
