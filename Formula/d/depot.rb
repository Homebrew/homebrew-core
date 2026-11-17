class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.25.tar.gz"
  sha256 "3130d0df78513fb4cb52a36df44995ba452d04541b7b2464be01a9b9214af2c6"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b008b2156cedee0584e9b163ac9fb8fed037e2b250210052daf0da6945becab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b008b2156cedee0584e9b163ac9fb8fed037e2b250210052daf0da6945becab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7b008b2156cedee0584e9b163ac9fb8fed037e2b250210052daf0da6945becab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0266367e5b7d528991a6839bbe93d7a7d2133e0633df0e6b95721795810bdb06"
    sha256 cellar: :any,                 x86_64_linux:      "d74ccd909fb5978b1884a01bb174e3308d55a3d8a9cda167b3d4786227edbc02"
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
