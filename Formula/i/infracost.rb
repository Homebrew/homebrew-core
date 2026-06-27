class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "b4b11e8d6a6665c9334ba0a537fcdeb7ba8bd7151ef38a73d40eab3b8149adba"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ede4b17a6e2d4a72436c94f5ab8e85d0f605e48c30f20bbb6b715c93fb42940"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ede4b17a6e2d4a72436c94f5ab8e85d0f605e48c30f20bbb6b715c93fb42940"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ede4b17a6e2d4a72436c94f5ab8e85d0f605e48c30f20bbb6b715c93fb42940"
    sha256 cellar: :any_skip_relocation, sonoma:        "f91ae842d2c46d3f8cea9112d05de3b97bc10cc1dc4e4988486baea85683563b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71f04c538a058fa15e6604ccf8e9385ab631fbb625c2b1c1154acfe258ba31e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9dd0947a46776c7cbbe435e18c52325edc34ba6e0489a08c7d4e8b96c126dd1"
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
