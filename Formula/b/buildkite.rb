class Buildkite < Formula
  desc "Work with Buildkite from the command-line"
  homepage "https://github.com/buildkite/cli"
  url "https://github.com/buildkite/cli/archive/refs/tags/v3.68.0.tar.gz"
  sha256 "6ad9ef66a18346d0c6d2fe3a66c09165f874649a400d99bd82335eb453335c66"
  license "MIT"
  head "https://github.com/buildkite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a8e7d90084e71f793cfab25ef6b8af729fa7caa06eb0ba49322ad7a68eeb5ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a8e7d90084e71f793cfab25ef6b8af729fa7caa06eb0ba49322ad7a68eeb5ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a8e7d90084e71f793cfab25ef6b8af729fa7caa06eb0ba49322ad7a68eeb5ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f1623af050a79f14e798cc0eacd61116dbb51a85e7bc2e4ff51f9c77ad8c319b"
    sha256 cellar: :any,                 x86_64_linux:      "bca6dfe7a15c1b408b266de2e123059a33ef4ee4e333d348afdb5cb7b3e041ec"
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
