class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.13.10.tar.gz"
  sha256 "1cff0c45f710196a944d43bee1ccabc7c68a89d51ecb95af02f71e4bed38f3de"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bd5c4830e5858377c5d887c72f0bee48f0f9da263eac9a84636fe4e51c95d12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8a3b106c4ca1a96c0a4c9c9a935d4b95d18080eb3e44820c65cef4de355dde3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f427c8fc544c38ab855dbc339ced1792836fef3eb402f1ea72720abb018292b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc3735950c3324c1e7c97e94a0fe56531bcb167e2c7d82aa732df3b127ff8f33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9693ed125c1731b454b4a69d820804026bd216a454c3141cf5578caafb8d5e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d670343719a604d2324efc88f426858d53c08842ef36017935de5f3250181e0d"
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
