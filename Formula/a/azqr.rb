class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.4.3.2",
      revision: "6a22f44805b606cde8b781d60f9e2afed77b06ca"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82fa1f2881d8d4bbe5e37a2d5cb5987f3c631ddc21feea1f8e6a158eb9d3d583"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "82fa1f2881d8d4bbe5e37a2d5cb5987f3c631ddc21feea1f8e6a158eb9d3d583"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "82fa1f2881d8d4bbe5e37a2d5cb5987f3c631ddc21feea1f8e6a158eb9d3d583"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0314c40f2158529196f71e04408d8c0d63c36c79636a3dbf272fbb9453db4e80"
    sha256 cellar: :any,                 x86_64_linux:      "16effa444d68fd3d6c9002eddf1f8c53194cb9083f27e63ee02cfd2b2f34a1cd"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end
