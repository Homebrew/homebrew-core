class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "0ec2b1e58d6b155bf6842cb1242592dbfb89c489c9f400f4f4c1578cfbf25810"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24298fc320672de872d15a1d65ca0ea13a7c75a7543b79379ba3449888225962"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db0341b5e3b2a022553403be113a45186bea9e98fbd6a7c131c472c8a748c067"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b5eb587884bf5653e4de441c6fe3b154fe5446b2e7b59c5a8802539b0910f25"
    sha256 cellar: :any_skip_relocation, sonoma:        "3aa58523eb3b7f45dbc6021ce91d78ab1433ad19ace582b7f4bc558d87aee8a1"
    sha256 cellar: :any,                 arm64_linux:   "70b568d431eef340d5264cb07617ccbb739b3be47bd2fe01f3e07fd67497963d"
    sha256 cellar: :any,                 x86_64_linux:  "6a4e02405f1d050dbf498307a2b32104f0ce88767f9f00caefe1b84e3be1da99"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ldcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end
