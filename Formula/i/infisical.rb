class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.44.14.tar.gz"
  sha256 "634275dce4a3aa49ce8d6f70968e1825b0049a4087306ddd73496ba30a155388"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3f4ca02bf93e3edb9dcd216025f28e1c0b611255af39451e848fa0439ab087ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3f4ca02bf93e3edb9dcd216025f28e1c0b611255af39451e848fa0439ab087ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3f4ca02bf93e3edb9dcd216025f28e1c0b611255af39451e848fa0439ab087ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "64b89b5f328b665895b1c11f5e400635ea1b897ca69de7aa330bc14c229b612b"
    sha256 cellar: :any,                 x86_64_linux:      "6d1c54236d75503f95503510c169930ac88341cf2a9ebb10323c638f83a95e42"
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
