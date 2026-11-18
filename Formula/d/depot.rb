class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.28.tar.gz"
  sha256 "e99e6f3ad494add2e772dd6125048523c07f5361ec5d0ccad60e40d32cbfdd78"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6fb556645ee2970102c50c0275b7d31c60e352a033e2dc53f9eed607745da819"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6fb556645ee2970102c50c0275b7d31c60e352a033e2dc53f9eed607745da819"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6fb556645ee2970102c50c0275b7d31c60e352a033e2dc53f9eed607745da819"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ac4d64f778e2d460c8823306d076df20f567140d7077cbc81fe15ae0b979e05a"
    sha256 cellar: :any,                 x86_64_linux:      "f9d2436bd975a7ff9cf3329ee8d3a05fcd08f732bd97fe115e2a4027bbcb67b1"
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
