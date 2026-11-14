class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.17.tar.gz"
  sha256 "ab2ba78017ec1dd82fd2eff2982b1ececec5e3e9aa6a5704186c26af8558d2a4"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f850f640ae0441903a519450fed16148f995a17b3e2aa11d46216bb8bbc8b1c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f850f640ae0441903a519450fed16148f995a17b3e2aa11d46216bb8bbc8b1c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f850f640ae0441903a519450fed16148f995a17b3e2aa11d46216bb8bbc8b1c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0399d47ccef43cfc2dad26f05ee7d3fe6628c71beae4822b21ae2f9f25947adb"
    sha256 cellar: :any,                 x86_64_linux:      "b077a495614ed8615748420f9201b4d072737becbc5c102e03f0e36be898ea1f"
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
