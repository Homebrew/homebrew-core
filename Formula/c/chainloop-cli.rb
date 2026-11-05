class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.132.0.tar.gz"
  sha256 "ce46f8c0c26477e744895a4b0e13a133b515cb39ddad68bfc92735f967cb33c3"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2a3daa799c77fcb626287f81dee57428eadaff6521bbc7f00b5a7a6257d49d60"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2a3daa799c77fcb626287f81dee57428eadaff6521bbc7f00b5a7a6257d49d60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2a3daa799c77fcb626287f81dee57428eadaff6521bbc7f00b5a7a6257d49d60"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e3e8d15296709018c03a3e224cd075f0867f14bccd04b861753f54038b9ab557"
    sha256 cellar: :any,                 x86_64_linux:      "b3b6078b5d64c8c727db57d9fec35ad06805778fcc6b3971ebd2a7e628b82dde"
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
