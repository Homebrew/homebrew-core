class Buildkite < Formula
  desc "Work with Buildkite from the command-line"
  homepage "https://github.com/buildkite/cli"
  url "https://github.com/buildkite/cli/archive/refs/tags/v3.69.0.tar.gz"
  sha256 "96681b1a8772a04e28318af0e969dac279339165e05d238e8d05ad15f13cb43d"
  license "MIT"
  head "https://github.com/buildkite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a57146ef9c4d49b47df04c16511f7b312fd9432ea53916b6446e78cca0b52ed8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a57146ef9c4d49b47df04c16511f7b312fd9432ea53916b6446e78cca0b52ed8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a57146ef9c4d49b47df04c16511f7b312fd9432ea53916b6446e78cca0b52ed8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3dd73f61e552805f9f442a889492e3435273f832d9c8a9fa22085cd309b79997"
    sha256 cellar: :any,                 x86_64_linux:      "adf9dd131c546a8c188b0454048d18e6d0dc938dfeef44a70a3cbd0321d0b602"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/buildkite/cli/v3/cmd/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buildkite --version")

    system bin/"buildkite", "config", "set", "output_format", "yaml", "--local"
    assert_equal "yaml", shell_output("#{bin}/buildkite config get output_format").strip
  end
end
