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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d6befcb80ac2ca74c87a22432e1cfb477267eb330400d790e2105a497f4edd24"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d6befcb80ac2ca74c87a22432e1cfb477267eb330400d790e2105a497f4edd24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d6befcb80ac2ca74c87a22432e1cfb477267eb330400d790e2105a497f4edd24"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "332802b1307b1d221e49a531f5fa5fa120b1ae377d2fd2f6b241f1ac1199a6c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "df008818cc50fa1b2546bb4b52413d22329b58a5af1e6882d6d786265e743948"
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
