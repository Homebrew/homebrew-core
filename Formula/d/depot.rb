class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.10.tar.gz"
  sha256 "e0669267567c7515500fc82aa05fc4e3b00641c25925e4cdd44ab6dae41e1c0b"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a13d78e6a1d44c9e29054cadf1e3f65f752475de3896d87e056afc57694dd792"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a13d78e6a1d44c9e29054cadf1e3f65f752475de3896d87e056afc57694dd792"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a13d78e6a1d44c9e29054cadf1e3f65f752475de3896d87e056afc57694dd792"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "582b9c2fc405c3310f20228a24e9335b839f2d283e28c6cf3b63fe9b53e799cb"
    sha256 cellar: :any,                 x86_64_linux:      "659aa225202730c481764e0ea65cb7e3fed669e1f102b04390363563abd2de96"
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
