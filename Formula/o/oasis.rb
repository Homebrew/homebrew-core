class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.18.5.tar.gz"
  sha256 "d18e84f2de061944b2e36b6842c7841463c3c448c318c141fc70d16c92cebdcb"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64084c58a254efa4ee65cca0ce85da5077108f260ae11026d1e2671c6b702fa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab2e03f7f23391e08f11d7e3d931f9581f12db7f669f9caa8d2a4954a61a212e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19c5c1148840be6aafe3690bc4ff89eb0d8271d2e9dfb74cbdce8763bb7d9334"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b1fd40a83e07b223d510d671c557a3496f535b7542a229122ef4dc8d9f8c85b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a82e0e7359489d61ab8c99ba531eb46aa99bd736ed6be1fb7ede3f5dd2debb36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c62e6eea739061fa3fbd6404f0bff990649d364e45681f77ba4137db6e58b0f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/oasisprotocol/cli/version.Software=#{version}
      -X github.com/oasisprotocol/cli/cmd.DisableUpdateCmd=true
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"oasis", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oasis --version")
    assert_match "CLI for interacting with the Oasis network", shell_output("#{bin}/oasis --help")
    assert_match "Error: unknown command \"update\" for \"oasis\"", shell_output("#{bin}/oasis update 2>&1", 1)
    assert_match "Error: no address given and no wallet configured", shell_output("#{bin}/oasis account show 2>&1", 1)
  end
end
