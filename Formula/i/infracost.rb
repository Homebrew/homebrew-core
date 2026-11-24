class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "0b8a3bf7c76f4ceb59f68d7082bfe3fa55bad74e89ac823c6204049ea6d6c7fe"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "6243339fbbf8806017ae63d8902776a5dbca4ab5e47255da4c12466e16b31ebb"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9a907156ebfbb7b844b396dcee7e1a4e4adc007bab67101cbcc3e6f8222ca1bb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9a907156ebfbb7b844b396dcee7e1a4e4adc007bab67101cbcc3e6f8222ca1bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a907156ebfbb7b844b396dcee7e1a4e4adc007bab67101cbcc3e6f8222ca1bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "adc61f8367048de5b72e4e52cfba6e69676fb14e221e2b4ac149639f9aaf9b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6910da0957e6ae78ef075517453367048b6c62c4f4efd61f397a14d66ad69e51"
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
