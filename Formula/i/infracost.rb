class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "922b4e01f59e23eca8679a88bd85c9317b60777fe3f8f0199ffcd58eaeac320a"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd9729aa76d34adefb60b0b94829103e3e95610508de5a22744746439b62a859"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cd9729aa76d34adefb60b0b94829103e3e95610508de5a22744746439b62a859"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cd9729aa76d34adefb60b0b94829103e3e95610508de5a22744746439b62a859"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d74553805a0ea89d37030c4e5d9f9c3a5a12ec2f6a07c4a43d4d505d48add4ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5cd66e72d9918d87e38dcd0d30b73331173608b8239591dac1a9439b25d88208"
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
