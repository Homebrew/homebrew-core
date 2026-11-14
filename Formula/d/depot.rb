class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.18.tar.gz"
  sha256 "3c90eafb506613ee52963d375771e5a90d1c4221386e7ec574183492039ea5e2"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8aaffc3e504c2a238d6bcd100ff928ebee0edd8629f652cc373c0877fb096c63"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8aaffc3e504c2a238d6bcd100ff928ebee0edd8629f652cc373c0877fb096c63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8aaffc3e504c2a238d6bcd100ff928ebee0edd8629f652cc373c0877fb096c63"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c3e402f104bdb3f220fc008a799a060dca5d038f75b554f38b0c403f4a2ecaf6"
    sha256 cellar: :any,                 x86_64_linux:      "e1eb10f3a3a0583f38774dab901d3cd4e078d4b8fbea8579ddc5a9ee8a11f68c"
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
