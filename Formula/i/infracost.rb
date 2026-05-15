class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "649f124545c4b71332b093cc15b020315e1eb3372d7cfeca61e05dfceac5b2a6"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bb069db1c641df3375b724b872141cc1ed1cfd129d2d68aa83f68f5020b0306"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bb069db1c641df3375b724b872141cc1ed1cfd129d2d68aa83f68f5020b0306"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bb069db1c641df3375b724b872141cc1ed1cfd129d2d68aa83f68f5020b0306"
    sha256 cellar: :any_skip_relocation, sonoma:        "963770a189b8cea78ae89b1de8490100448b0b0d6fe50cfc4b68203e867b59af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d3f5966325bf7db2f0ff119494da65ca805e0b6c5826f8f4563b9720a6e93d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0fc593501ddf05b010a0da1668cc1b2d4c4a056068e6666de6b63f744e87db8"
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
