class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.45.2.tar.gz"
  sha256 "a23d3e534ba25fa834862beedc93b258534f8c06ec2511b2d9f2f744d8266b21"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "49a9cfbee13a3f2412fd0c6a13967f7784539d3b5bcf0ac18d95fcb1bc77e471"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "49a9cfbee13a3f2412fd0c6a13967f7784539d3b5bcf0ac18d95fcb1bc77e471"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "49a9cfbee13a3f2412fd0c6a13967f7784539d3b5bcf0ac18d95fcb1bc77e471"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "39c68a8a9d2f34d2b40bd100c7d2a71803436738184a0c29f4cc85f4fd46187a"
    sha256 cellar: :any,                 x86_64_linux:      "4ecc1ab96ec2d9aa3996d48efa90da790ef15b69cda782725e99e394915451e3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
