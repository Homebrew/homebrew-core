class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.102.9.tar.gz"
  sha256 "3cbcfff5bd880b2e00461915c5e4d54efed9799b40f8e89bbfe20fb16230d380"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b80d99bd2b70708353dd8cd5dedc4f2370d88babf4d6b6cd5066ee5bf30d678c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b80d99bd2b70708353dd8cd5dedc4f2370d88babf4d6b6cd5066ee5bf30d678c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b80d99bd2b70708353dd8cd5dedc4f2370d88babf4d6b6cd5066ee5bf30d678c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a8665ad38025a5c8d26554c4afd7b24676edaf4c0ce42c3fd71d7a7bc7f0e0b3"
    sha256 cellar: :any,                 x86_64_linux:      "153ca541058889ee94c0bb81bddd29e610a14dca4e30048170aa4f78def2da2a"
  end

  depends_on "go" => :build

  # Fix linking on Linux arm64 with Go 1.27, which rejects cpuid 2.0.4's linkname to `runtime.sched_getaffinity`.
  patch do
    url "https://github.com/depot/cli/commit/627f8a6dfad7e7f2f33c774d3aa22af9884f0ebb.patch?full_index=1"
    sha256 "bffa3eaea34bebeeb3c27fb9ed326137b8824a1ded170eeeb2cdd91c30dd48ac"
    type :unofficial
    resolves "https://github.com/depot/cli/pull/570"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "unknown project ID", output
  end
end
