class BitbucketCli < Formula
  desc "CLI for Bitbucket Cloud and Data Center"
  homepage "https://github.com/avivsinai/bitbucket-cli"
  url "https://github.com/avivsinai/bitbucket-cli/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "c353fd4f1d4577e581d9161b142d575da91866f2d04f8c92da876e090017043a"
  license "MIT"
  head "https://github.com/avivsinai/bitbucket-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f168963cd33e0628b23ccaae5cd7d71beee897e549d6264ef32373f0c0e0dc81"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "303581d25d687d8959c31a1aaf733c722f24fcaa4a5439363d7feb27b344d2ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29f8406bcc84829f0d45b4268f74a1f272198dc6d08a2660f62d155a3c6e62b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "85d850758eeb41a1a71874efc941c28e84d5261ef7d77b1b53f3191e6ae5b5e2"
    sha256 cellar: :any,                 x86_64_linux:      "09361ddaa432be8aac83429599d520d5947dc37a868b82956e2de96bd04591b6"
  end

  depends_on "go" => :build

  conflicts_with "bkt", because: "both install `bkt` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/avivsinai/bitbucket-cli/internal/build.versionFromLdflags=#{version}
      -X github.com/avivsinai/bitbucket-cli/internal/build.dateFromLdflags=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"bkt"), "./cmd/bkt"
    generate_completions_from_executable(bin/"bkt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkt --version")
    assert_match "No contexts configured", shell_output("#{bin}/bkt context list")
    assert_match "no active context", shell_output("#{bin}/bkt repo list 2>&1", 1)
  end
end
