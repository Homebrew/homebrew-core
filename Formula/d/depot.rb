class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.21.tar.gz"
  sha256 "320d3e36b2644753aa849ea8b193347603f8bbeeca569d56fbe566d8b0da58d0"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f4345222fe014ddbf192fb5a317ef1e3fbf26f67f78d39242fa991a2e4b10699"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f4345222fe014ddbf192fb5a317ef1e3fbf26f67f78d39242fa991a2e4b10699"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f4345222fe014ddbf192fb5a317ef1e3fbf26f67f78d39242fa991a2e4b10699"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7f95290bca0c30591af225555342e578dff926f6c7260c1f738c7c698d432060"
    sha256 cellar: :any,                 x86_64_linux:      "fba8bd5a68e8ca95d77ef90826da261a8ff57506fb1db5a84154b2def9cbd8d2"
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
