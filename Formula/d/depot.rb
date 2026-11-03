class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.7.tar.gz"
  sha256 "63b4587b95ab4346e7352d6906c16399b8b140ee146af2c5778fcc95781adfa2"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a0fae3d38dea58db780c5ea4757f7464258a06ff707c57e21b128e42b154f1b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a0fae3d38dea58db780c5ea4757f7464258a06ff707c57e21b128e42b154f1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4a0fae3d38dea58db780c5ea4757f7464258a06ff707c57e21b128e42b154f1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b68d1a45fba718a72a2e19fcfb5f0668a43498a04a557d945dc881b4e46a0c94"
    sha256 cellar: :any,                 x86_64_linux:      "da5df763bf5c45b6c3e5665aaeb75a0aa3b59a63229e56681c2bab18c295e928"
  end

  depends_on "go" => :build

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
