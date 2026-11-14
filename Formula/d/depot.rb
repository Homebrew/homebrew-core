class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.16.tar.gz"
  sha256 "7b19a1f450b35664580c555d6a773e9fa12898f6ed880c1135ff48c69be1bc0a"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1fdbc18d89caf37fc6319e3e41d2cf215940103a33cba42232782fee9c7cda64"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1fdbc18d89caf37fc6319e3e41d2cf215940103a33cba42232782fee9c7cda64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1fdbc18d89caf37fc6319e3e41d2cf215940103a33cba42232782fee9c7cda64"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c62126c2a883358b5ccffb8314df4e8387d272103d41a9e93043d0381698d1ca"
    sha256 cellar: :any,                 x86_64_linux:      "6f3a366566cf5f1d7c354d7caa5dee2409e51712cc4b5256c224ec859c3cbfce"
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
