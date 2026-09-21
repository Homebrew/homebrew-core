class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.16.3.tar.gz"
  sha256 "a8145d35e005ed67c8faf95ea558ec085bbed6550b1b70277e38f0d902b2f19c"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df7939216309d8732a29ceddb7330e127c83dbc6511a741accf968c4b59524cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df7939216309d8732a29ceddb7330e127c83dbc6511a741accf968c4b59524cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "df7939216309d8732a29ceddb7330e127c83dbc6511a741accf968c4b59524cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "df7939216309d8732a29ceddb7330e127c83dbc6511a741accf968c4b59524cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dfe08160ee2da236a485d2bc47dbd2e938348764c1e80d9724ad91aee075d996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "67648d1538ac5f31b7c03f75b45e924c43fae8ba4213bf43505e9da0bf2122ab"
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
