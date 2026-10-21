class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.14.3.tar.gz"
  sha256 "a44324139d82c3519aeaf5b07355a39da69233c20b8c0c57312c08757979e1a2"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66c1344b8dfe8a3dd1c5cc1f55df82709a93958f260de38abced55eade65f86c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22eda95b361d588a0526ce47add0c6b8e7e40c26c8b5eb52de5c7ed91792a062"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d2ee8801ac288bb8a667a74dd84cd9e0f72cfb0e31a6fba04fa0acaf8e0d369e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6cda274fb9cd0f67b6920daf03ad51eeda107b9ee4ef73ad8b42c0ff70146955"
    sha256 cellar: :any,                 x86_64_linux:      "783b0ef515ac4cdcc82e200c06e8c4a9bcd28352bf0ef4d7f7439095cd35c41a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/epinio/epinio/internal/version.Version=v#{version}")

    generate_completions_from_executable(bin/"epinio", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: v#{version}", output

    output = shell_output("#{bin}/epinio settings show 2>&1")
    assert_match "Show Settings", output
  end
end
