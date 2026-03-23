class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.86.0.tar.gz"
  sha256 "2db0c8f2cc121e97c1c2305ce12ec27554ad618b37422ea61241a69bbfac9380"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a5f0ad68da59f8b513c2260eda3700d1b93a9a80dbc424d850ecfe541b035d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0fd9723454ffadb6d44dded8a90f57daf957e147fea33945af77cca942de56d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0bb4876c29ff34dc3b28e321625bb3b1341c613ad33b157a6320ebf691aec6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ddfff600440915e76c46ceeae39d135508eeaae38fbae0bd426809e5ee7da78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "491aff82f074d9f1ccbe697c41271f4419a0b220c54daf5eb164cbd1c9c36cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "351f2c9e1e10d6852c4f5950374337c356cab7148132ff5351294499cc89cec5"
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
    assert_match "run chainloop auth login", output
  end
end
