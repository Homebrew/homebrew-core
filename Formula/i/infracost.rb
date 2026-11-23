class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.20.1.tar.gz"
  sha256 "a0d8bd10e260a8e8855ce4e7428aa54515a79bb5ea5260f059021d5c76991a66"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "7d2818adb48055243560131c5fbd91e4c76372bf78f44bb3c40f7be58a394512"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1cd1ed2e41818422e6d52e765ed5fdeb43f05a09e190284b62518de2847ee8f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1cd1ed2e41818422e6d52e765ed5fdeb43f05a09e190284b62518de2847ee8f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1cd1ed2e41818422e6d52e765ed5fdeb43f05a09e190284b62518de2847ee8f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "52055e7232f8107353ee26ac6899baabb0c6c18841ad9564d0c9f81fad9be1a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "db600f4a4e2e0173610123f90fbc0b64078b4359d28e3289bfde1d67c54451bf"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/cli/version.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"infracost", ldflags:), "main.go"

    generate_completions_from_executable(bin/"infracost", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    ENV["INFRACOST_CLI_AUTHENTICATION_TOKEN"] = "dummy"
    output = shell_output("#{bin}/infracost setup --no-color 2>&1", 1)
    assert_match "setup requires interactive login", output
  end
end
