class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.38.tar.gz"
  sha256 "f6b3d20275a1c11180d6d1fa0ce6d6d156ad72fb4950e2fc29a0a68f357e2726"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb3d2873f682a1924a3ea2c6b0eac0b42a43a2fd9b7007edd8bda9df970cd9ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb3d2873f682a1924a3ea2c6b0eac0b42a43a2fd9b7007edd8bda9df970cd9ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb3d2873f682a1924a3ea2c6b0eac0b42a43a2fd9b7007edd8bda9df970cd9ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "4aac319065716749e5bdc64d323a658de8a85cf4f4a1f74db07e136ee577e136"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b77888ad37d184325abbbffd562a70e731809bc50705bd217ed6e8631766fecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ab6f06f02c6ccd7febb7e3b9b5edb89a04ae37a192b626653f607dc4333b056"
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
