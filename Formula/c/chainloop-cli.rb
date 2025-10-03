class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.45.6.tar.gz"
  sha256 "7bfeb69254727012e93c8885d7680774b2c99b5227235d1f3b69c926f8f56bce"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00b4503a05760ef0cf97dfe0732f3b35fc443f7d0d61f8b52e1b20db8aed32ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "137aa612b7daae9e8e6d5242810fc8f512890b7983857198b13fadeb65320e08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af9669457936dd9b30e2d46c8a11d4e3968ea062a1e90cf04e8fab3cc4af5d22"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3446d4b6c598904b81462bbcec97d397ee8be3511b6a0f50cbde8f3f4622bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bc20295cefc9494defb0879b8faf47c6c61bdd6f115c35119d1bff11acd9372"
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
    assert_match "run chainloop auth login", output
  end
end
