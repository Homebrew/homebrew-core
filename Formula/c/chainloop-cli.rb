class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.135.0.tar.gz"
  sha256 "7588ff7104cb9811c4a2b9d97a5e469f3a0cb3245273e0ed93c755e6aea71009"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0609efb7778c8dafb729a39a1be18f5b1f88a2d4ef6db8f2448991b12eadddb4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0609efb7778c8dafb729a39a1be18f5b1f88a2d4ef6db8f2448991b12eadddb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0609efb7778c8dafb729a39a1be18f5b1f88a2d4ef6db8f2448991b12eadddb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "94a2f732f07cbcdde2a63967c0aab1bdfc54890e001a5d0f35797fb27f9ad41d"
    sha256 cellar: :any,                 x86_64_linux:      "ccc593752e875c125b2b95c1d0a7f96eb43c88d98fcaf16529b5164c5b227e1a"
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
