class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "3c22763a891c2aa0057a2c51e56732971c2cf86a575631096ebb43fbf10960da"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6d27579fc1330a937d80b45064d1c29e997e98eb887ed898dd55cd5255230bea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d27579fc1330a937d80b45064d1c29e997e98eb887ed898dd55cd5255230bea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d27579fc1330a937d80b45064d1c29e997e98eb887ed898dd55cd5255230bea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0392a88158363a5495c01475014e3d599683867a5e2f123cef34cb212636d952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4ae3030637763ca71ac37b7fde7ff752595feb0084c9ad5f014327f736570c9b"
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
