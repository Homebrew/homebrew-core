class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.31.tar.gz"
  sha256 "9469317d1b9c6eb6fbc180f2a72c7781ba6f83e52589ed0df433d6372c510359"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "27064b4e78f8a674a9892a6b5dac192a01a41a3c429c73c7e314db6cb1f06a46"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27064b4e78f8a674a9892a6b5dac192a01a41a3c429c73c7e314db6cb1f06a46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27064b4e78f8a674a9892a6b5dac192a01a41a3c429c73c7e314db6cb1f06a46"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d4fdbbd6ff8d516928b0cac03b9c7ec0727a2982c2e8380efa05fbb3c85e1919"
    sha256 cellar: :any,                 x86_64_linux:      "43c8b3fc4c675ed6da91851838b49c5c2f151d06f7538c4223e380ff92160fd0"
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
