class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "ad8718ddd370e1bc7a65bed0c71c5686cc8dd067bf80a51def17008fdff53115"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7af216e2b7e24abede7a7da6944efeaddc8389f513323733246c4d9a56d7fd68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7af216e2b7e24abede7a7da6944efeaddc8389f513323733246c4d9a56d7fd68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7af216e2b7e24abede7a7da6944efeaddc8389f513323733246c4d9a56d7fd68"
    sha256 cellar: :any_skip_relocation, sonoma:        "c50f5faf8d09a5a61973dcd84d4bec913235dacb097a188031455f5c2e3e32d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b13af423861d01fcbad4f14f27b55b50142b25113bf79fa64941dd8af28d147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45c25ca41f0872763ff5825c5c9917b8b6c38a93235cab9593fdd80a0190558e"
  end

  depends_on "go" => :build

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
