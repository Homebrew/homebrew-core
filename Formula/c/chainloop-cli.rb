class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.99.1.tar.gz"
  sha256 "303d869cf2f51d99a422355b69a73610a46272778c33b627398aa5e4bac6288d"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "575ae9fb9ba2ebaafa8fc96f51048810368ac3c91f310d36a8faf7da2751e815"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbdf8abd8827807e40afa4034e51d6efd8b901c93347ade53706a885c56f866f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "272ba1a3c8d0f06e8b8d9641cee538e0dc79dff9de13e9c26d1bb68a826c7e65"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ccefddea444f05af7ffe4b2fcd60251edcca94a42848b97fa1dfd85a0c9d40a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40590ad6b164c6d1423847488eb8f5d598ddb08ad922bf35b56c491d0d335a53"
    sha256 cellar: :any,                 x86_64_linux:  "64c7bc57687a416849f9a9d639f0844b42e1009339f9890000503e7cc98cbe83"
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
