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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2113a540020d5ddecf610d0a564dcbb725662ac2e8be61caf406375b89366417"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2113a540020d5ddecf610d0a564dcbb725662ac2e8be61caf406375b89366417"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2113a540020d5ddecf610d0a564dcbb725662ac2e8be61caf406375b89366417"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4ef86053a6cfb86f147241e230c5788bc869ee4adf908b01d453401125b2f2de"
    sha256 cellar: :any,                 x86_64_linux:      "8e797d1c0035249863fe0bbcfce040334dbf25c4c1d5fa3779eea712eed96790"
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
