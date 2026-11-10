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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6848f8225e5311f2638980dd7f2766fe6b6da7214c6e30c5d91602a9826593a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6848f8225e5311f2638980dd7f2766fe6b6da7214c6e30c5d91602a9826593a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6848f8225e5311f2638980dd7f2766fe6b6da7214c6e30c5d91602a9826593a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3880063d884bb494509dfecdcb7df826941a3841d91f1091d6192b16e93dc422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bdb6975da0360728986bfda95b85604a29b8e52c25eb81e6980f136500c93a58"
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
