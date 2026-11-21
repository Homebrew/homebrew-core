class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.33.tar.gz"
  sha256 "acbd39479157e3668e3bf70793398b031a7a7b3ee82afae93a35f4346ef8c564"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "5f02bdceae08c92969513e6636b970bc5e32bcca495756a1ded42b3f13880e91"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "219f86fe4adb1b6f4f12de63a49edcfae637a70e5dcd9e84a475e30941a16c07"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "219f86fe4adb1b6f4f12de63a49edcfae637a70e5dcd9e84a475e30941a16c07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "219f86fe4adb1b6f4f12de63a49edcfae637a70e5dcd9e84a475e30941a16c07"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8ba2606b1071ca88c9aa547f24495175382af5e56cb4a6fc5ce4285a3cace78f"
    sha256 cellar: :any,                 x86_64_linux:      "8e46ac827d11b31d079bd574d85f7ee7edf65d7bef85735f5da2676cd673f6df"
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
