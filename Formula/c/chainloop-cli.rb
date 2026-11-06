class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.133.0.tar.gz"
  sha256 "ba3b98d2ce6de84b51995af960766e34424ee693853576dc40076230c2cdb3a0"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9fbf06ad58cd1b9af945ef5ac6ea8382f124c71099d757a24776745b6721b06d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9fbf06ad58cd1b9af945ef5ac6ea8382f124c71099d757a24776745b6721b06d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9fbf06ad58cd1b9af945ef5ac6ea8382f124c71099d757a24776745b6721b06d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d50b11efaaf3f78e16fffc408fe4febb973e8b2c897f3db4ca0c3aed6d99e1db"
    sha256 cellar: :any,                 x86_64_linux:      "7fe85c244324a93654eda5031f6d22077b7de20dc921ec4f030ee629c511689c"
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
