class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.1.tar.gz"
  sha256 "8741a228bbf53d3c40cdb6b6ac82b847716bbbea1f23a406d823e9aee8cc9e88"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cd6be13e945393fe1aeca94d392c605217c317f8c4c9cea3a61cd2789d202de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cd6be13e945393fe1aeca94d392c605217c317f8c4c9cea3a61cd2789d202de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cd6be13e945393fe1aeca94d392c605217c317f8c4c9cea3a61cd2789d202de"
    sha256 cellar: :any_skip_relocation, sonoma:        "08a6ac0b2e5312e24c9ca4d69c2bdea66f6d2d552cf776529ff057841244d225"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45df34d15ad8efc5aff276a8ba9e0049c16e4f5189da67b186af6541744d77ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a98e349222bcf8baa59b07af900fe6384349d55d6c600db4725407a0a737596"
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
