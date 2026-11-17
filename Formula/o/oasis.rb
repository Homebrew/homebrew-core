class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "3e8aba8dc9bed9dfb89c0ee970227e16bd2895959c78a2388b53efe8e87f0e2a"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dbb7e25bdfbb9debda8dc40a320cd357b59b7e814f9c4db39c94c1946032810c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "539ee4cbf44f20696a7f04369e31a32bc93b74c8735c9feacccc1b7ecabcd2de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6405973eb9a480aa8bd39805e9926a175a217c308cd90725372e825109a7ba32"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "866758fc26de5f54fd2f7e80fb0b512115f54d82d60b235a9a3fcdfd43832a5f"
    sha256 cellar: :any,                 x86_64_linux:      "393ae9fc6eb24d3cc1ab08dd2d8cd65bd240289bd01d6f8a315e443ff7a5c865"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
