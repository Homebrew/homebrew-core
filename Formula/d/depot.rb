class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.40.tar.gz"
  sha256 "7d46d08e52d8eead4977c47b5fe15be2ecb6b2ab91a64dafe0bdc54b889b5be2"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c567e5ab3b8099064e53d86cfe12d0aeef1e2109fcf1a9aceeb9eb8e5ffe205"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c567e5ab3b8099064e53d86cfe12d0aeef1e2109fcf1a9aceeb9eb8e5ffe205"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c567e5ab3b8099064e53d86cfe12d0aeef1e2109fcf1a9aceeb9eb8e5ffe205"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9aa5d219f94bbe270261821dd25ed017ebc75451c6590f72e2302b8bd5a0b53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8b7d9f9134f8bc9a844f52e3492ade1f9b17fc450a5c96ef45fc2930b3f2b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9431edbd45c4c404f1e36b2ada111d836cd4df24c8a1d4dd19b689e9b52d5d0b"
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
