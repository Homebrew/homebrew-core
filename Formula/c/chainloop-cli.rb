class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.130.0.tar.gz"
  sha256 "4a72eae759dfb02a4afca1dafc107ca2cc7d2ad7d023ec2f1a84c56a61e2b292"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d8f4b455a99b4d166fb89829ffd584cc8258bc44f81d6116dd0128da28d4ff05"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d8f4b455a99b4d166fb89829ffd584cc8258bc44f81d6116dd0128da28d4ff05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d8f4b455a99b4d166fb89829ffd584cc8258bc44f81d6116dd0128da28d4ff05"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "52c704e615aaa7106cb03f3830886885de2857d91d73d6a7efbfbbe76c0141ab"
    sha256 cellar: :any,                 x86_64_linux:      "f086a4b978fadd0bc24729542690b46c684aae7201534680269c952e63f8a989"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
