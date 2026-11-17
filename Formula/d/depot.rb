class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.26.tar.gz"
  sha256 "84eab2136105c7eddc75b8e26ed487bc94bd71ed833eeb930e452f7554ae0bf1"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8030a894f2757bdccc97a161938d6df3c83770bdb1a7f7aa6f0fd0366217fffb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8030a894f2757bdccc97a161938d6df3c83770bdb1a7f7aa6f0fd0366217fffb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8030a894f2757bdccc97a161938d6df3c83770bdb1a7f7aa6f0fd0366217fffb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f9a7655c8713602f9f48a1da510a48482dcef702667f7c44f72106672e8d8aff"
    sha256 cellar: :any,                 x86_64_linux:      "813c7bba61026758c0f974ecd04d5a0b11d442505b0e9842a990212d8a93dde8"
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
