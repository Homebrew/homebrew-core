class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.47.tar.gz"
  sha256 "cb9aa1e21801c76b80e73007b6ec2f7efd4e9c81dfff479844a56882f0ab27bc"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34464741133d04a37e3e4d76cef82377adfe8a5e0972110d585d8d5e2c499de0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34464741133d04a37e3e4d76cef82377adfe8a5e0972110d585d8d5e2c499de0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34464741133d04a37e3e4d76cef82377adfe8a5e0972110d585d8d5e2c499de0"
    sha256 cellar: :any_skip_relocation, sonoma:        "11e7bc309455863cfbd46d135af08b67cd89499bb887120397cf96936ff61371"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "886e8b080d5213db8a91a871c4db5887ece8cf35c514d95a238458c21f366eec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "744b05c5f74af2fa75447376af721b5a581683823d0bf92c79c438d2226cabb6"
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
