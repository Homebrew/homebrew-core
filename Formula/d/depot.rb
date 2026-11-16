class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.20.tar.gz"
  sha256 "fceb6456302791b0bbda1378cade40b5b6c08f524f7156b4f5de5e1fa181082b"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e1d51e707668d7829ea312d04445441ac57e3622aaac5052c97c2b9376b35ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7e1d51e707668d7829ea312d04445441ac57e3622aaac5052c97c2b9376b35ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e1d51e707668d7829ea312d04445441ac57e3622aaac5052c97c2b9376b35ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "27652dd1c8e273b91c359962e30a25fc853c5e0480be2eb48a319bb36f665ffc"
    sha256 cellar: :any,                 x86_64_linux:      "eb8c8542b9352bacdbdea1858f15f51b06da90997c9abebcf5391c64ecb4f8f2"
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
