class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.2.7.tar.gz"
  sha256 "db61a4d3aca3df9953b17fcb38ceefd78921ae5ff83bf1e766c987bb97e5946f"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dd1043b189baf226ba3fc05a12cf176c51e883d3ad4e6c29ee36729ea39fdf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dd1043b189baf226ba3fc05a12cf176c51e883d3ad4e6c29ee36729ea39fdf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dd1043b189baf226ba3fc05a12cf176c51e883d3ad4e6c29ee36729ea39fdf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1c7ad62a1216d46aa0ed0fc1e1e3fc733dd31dd5f1e3222643d7a962986806f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31f11ba48140b9867d7dff2d5d5cf3788aefadc9903a9fe402bcf74abf57a9ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce3b4b9e24085860bdcf894217cd4df45ef0d8e1d8acb9d693bc76cdd02c329c"
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
