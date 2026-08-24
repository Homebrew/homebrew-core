class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.16.2.tar.gz"
  sha256 "b147abdc4ce2f5da2ec7fe624d25c215b5084b7b006e620e146b55ab4b5b5410"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "134117d5ea0dc2a7f9a20f2b9206a3bc63d7425ed9281d04f5dd9e88b728f82a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "134117d5ea0dc2a7f9a20f2b9206a3bc63d7425ed9281d04f5dd9e88b728f82a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "134117d5ea0dc2a7f9a20f2b9206a3bc63d7425ed9281d04f5dd9e88b728f82a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f543d3c42a46f190fb861cfd05f438026d49a6bec62df3ef6e84a3110bcc53b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41d7051a5120bd7c1ad621f20671cf5137876e973afe5beb62db6670cecc25ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bc3209844b134854403e9b0aeaaece1bdb9a46708bf72c57a87f54c1be3e6e5"
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
