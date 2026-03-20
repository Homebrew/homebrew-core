class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.13.9.tar.gz"
  sha256 "c87b5c7d04bdee6f24d48b2814ece147240b1edec72331d86c4b669d399a6be4"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cfae1d834f2f7c6767e729148a7ef841b0930e561b10b780b2ce10ec0874356"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eca1534ecd2e5eb24b54315712fe70b949f341bae5d84d575c6565ce11011ac6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c74fd01e7da95d0dc3a15f01d470b423327bd6df4d8da9fcf09fbcd674e761f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bc71df548bfc304a5847648d6079b6a8c94f828d33f1d11ae7f4def7445c85b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7172c23e8b46aeccdaead2b645c444e4504d2ee38c74f1df7938d2e1ac7d149c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12cc47d5378c19c77f5f24cc70e832514ce9fb8e0746a570df57dd023013ba39"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=v#{version}")

    generate_completions_from_executable(bin/"epinio", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: v#{version}", output

    output = shell_output("#{bin}/epinio settings show 2>&1")
    assert_match "Show Settings", output
  end
end
