class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.60.tar.gz"
  sha256 "da78bc95ef4f284bbc3db2864c3b99dbafc323516e536ef4f1c78eced033b3bb"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c559cc3ab3b1aa3269bc7de4cdfdf3567b13245640bc2265d4fbc13a7c6293c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c559cc3ab3b1aa3269bc7de4cdfdf3567b13245640bc2265d4fbc13a7c6293c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c559cc3ab3b1aa3269bc7de4cdfdf3567b13245640bc2265d4fbc13a7c6293c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e182cbcec7abb8d1b5bd74dcf5789d28c46533b5504405d5fa8797d667ffbe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27b3f2a01171b95b058c4ca3ee5a6913af4b24601deb3d94880085168269d681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c423c356419d698d4030563b3dc049ea2958500bd97f62775743c8a5c89ee1af"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
    assert_match "Error: unknown project ID", output
  end
end
