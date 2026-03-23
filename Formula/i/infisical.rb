class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.60.tar.gz"
  sha256 "4542bc0e0747aa1b5e1e6b66add0a8de09201d95939afd97f88a5c99f175fdf5"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aadfa829846c70d6cdad97674ed935b21d7e0556385eacff80050465c7c1753d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aadfa829846c70d6cdad97674ed935b21d7e0556385eacff80050465c7c1753d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aadfa829846c70d6cdad97674ed935b21d7e0556385eacff80050465c7c1753d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfe329c64cf2f32d8ec3135dc7bd99d735c8faa27ba51d7b6ce6ecec3886a877"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54fa98cd97fee00798c776ad8c6e7b1f3d1fca784cf318c62bc37bfc54ef4953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8838413d1069088f7474dbaefbff86538417218eb9f6dfea2984d9734578e8c6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
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
