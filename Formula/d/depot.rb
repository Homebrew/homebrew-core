class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.6.tar.gz"
  sha256 "6937ce354aa76f3688b3665af8f8fe6a988282a0467f751f547ce56c4713bd40"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "52b9d18c5a3c35c91c7c0512f6e23f367addb1fb82b49a1866a1f91a8647f9bc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52b9d18c5a3c35c91c7c0512f6e23f367addb1fb82b49a1866a1f91a8647f9bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52b9d18c5a3c35c91c7c0512f6e23f367addb1fb82b49a1866a1f91a8647f9bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1e5863881ac3e2bdbd1ff09e59086e7c4776cbb3ad88ab664f3103b7d671dd90"
    sha256 cellar: :any,                 x86_64_linux:      "8a6275eef2cf3cdc24e0d536fb516680399f0409ebf726052735fe1e0fcda072"
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
