class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.89.12.tar.gz"
  sha256 "ebceaaf4fda114ada956a02e7b90be018e004f26e815e5ffc15144fd4978c406"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a56ecc230e9fcd4c9b3ff34e430d955de94ab2c9c89905596685ed6f5c17061c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05a76160bcfcefe4caf0ea08105850c355518105e33b40956f9c36f9137659b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5479dd291578ccf73f609fc30fdb23cd7996286f46bbea23333f793d1f2844c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "602b0e774827c9137cd1db76252a5a5fcc42bf02947bab04f9caeab3cc39fa3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b34541bdbf209dfa7445fc60369597fbd6cff5725b77b6fdc4a3e4a6c9cf644a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fc1ed7a1edd6965ebfac521f966a89310fd7363ba92df39b384578c3188dd0c"
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
