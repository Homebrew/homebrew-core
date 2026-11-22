class BitbucketCli < Formula
  desc "CLI for Bitbucket Cloud and Data Center"
  homepage "https://github.com/avivsinai/bitbucket-cli"
  url "https://github.com/avivsinai/bitbucket-cli/archive/refs/tags/v0.40.3.tar.gz"
  sha256 "63f52da774fc0a07b0108e0cde0881a3ef008a5f4789596e57852a6782b825e0"
  license "MIT"
  head "https://github.com/avivsinai/bitbucket-cli.git", branch: "master"

  bottle do
    manifest_sha256 "26c0a9659aef65ba3eb34e1bac67c88174543926d3c122e00f0698186097cb99"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc24919b48f6ad0b0c6be04c2f1f728fd7a90c4f84853e69d58e961c3b095b7f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8ba82cffe48cf162e361899c551731763cb8d8b6138fd24eec523fc8af713e7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "188b52b59a25110a54cc5dd6e52b5e9e42cce32911140b7226d3c661f282e5e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "83c72752f6fb50fa7ad0e15f30c3dcdab191e11016415903337b1ccc06b44257"
    sha256 cellar: :any,                 x86_64_linux:      "4ff8267ddabd399cebb1d38b4b78d670c066bc407d3dfa7f7a8bb06448ed7b35"
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
