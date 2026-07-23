class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.12.2.tar.gz"
  sha256 "8ae67067f1c2937300f92014b6f8211ff3f4a27827b743ba1954043cf798559d"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eba90c2829417f2965fa406447098e88b7fe6802b5bba0913898ba5e852d2318"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eba90c2829417f2965fa406447098e88b7fe6802b5bba0913898ba5e852d2318"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eba90c2829417f2965fa406447098e88b7fe6802b5bba0913898ba5e852d2318"
    sha256 cellar: :any_skip_relocation, sonoma:        "c57b455fc5b2c07949d7b308b483b324640c60bfc630054538ac075439cb8eac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d43bc95d18eb71d1e528d6405c7fd7e54427964a19d6165dda30918ed42a8687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87b3133699ce7538b222c613624f4b1171d98e9d9780d83e2dab6623a067d4ae"
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
