class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.135.4.tar.gz"
  sha256 "693a12666d82c130f83fee7b03bdcfc1846db4945b6956ccd7377244f2ac2ef0"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0cfaa76d97a5a25f69159160e515d3093e98939dd0da260e1bb8335961ae0dca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0cfaa76d97a5a25f69159160e515d3093e98939dd0da260e1bb8335961ae0dca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0cfaa76d97a5a25f69159160e515d3093e98939dd0da260e1bb8335961ae0dca"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "23de89d90af3cc1e1173573d047618e6ad040b2fc3170f52d505dc57e19f3c85"
    sha256 cellar: :any,                 x86_64_linux:      "834bae0a82834213c4fa4776c8f0c40d7a0c3c7982a62b230411fa922d40983a"
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
