class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.45.8.tar.gz"
  sha256 "3c213efd6d121a6addf3668b67c77d23729f8c2474140869186287deabda11c9"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "46fa6b46034ed13973a96980c5c5f147886cb78f798dc2998deb0a84381c6ab7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "46fa6b46034ed13973a96980c5c5f147886cb78f798dc2998deb0a84381c6ab7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "46fa6b46034ed13973a96980c5c5f147886cb78f798dc2998deb0a84381c6ab7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f060b70d3e5ac0097e1a40b4a27d96084ca23684784bc64bbc32f066cb1c50ff"
    sha256 cellar: :any,                 x86_64_linux:      "949276adfe5bf16d250b409e26204bdecce36881442b9659fb3c328e63de7fac"
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
