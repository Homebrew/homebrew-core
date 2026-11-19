class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.30.tar.gz"
  sha256 "4fb1ea4a76f11de27a1b9684659eea619bbb1310cf7fbfb0b6f5e76841d7b21f"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1bc37bf55100edb4c78bcfdca0af0cde296d08ba7118c28331c98da6a359fe98"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1bc37bf55100edb4c78bcfdca0af0cde296d08ba7118c28331c98da6a359fe98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1bc37bf55100edb4c78bcfdca0af0cde296d08ba7118c28331c98da6a359fe98"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cca90aed88ae78796b94ede25b5294e732081bf475193ad2f20d66d021b3f852"
    sha256 cellar: :any,                 x86_64_linux:      "e49d01e73e2bc463047bf2bbcd44ce876afc96f2aa006a5e34aecddd7aacef02"
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
