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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "51a32e4a46c5d790ea2349f5c96ab36a40b9c3e76de228ecfe8b30ee58fb8f78"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "51a32e4a46c5d790ea2349f5c96ab36a40b9c3e76de228ecfe8b30ee58fb8f78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "51a32e4a46c5d790ea2349f5c96ab36a40b9c3e76de228ecfe8b30ee58fb8f78"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c911ee7e902244e73e1927458d12c4f613052839dfc084b4d0f6cc0c5422712c"
    sha256 cellar: :any,                 x86_64_linux:      "4b5995d47b266dac2e9650373268210ec7cca1aca63870b13660655a8d9b2e2c"
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
