class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "4f290987fe290c4a23f29b1c14b2f7bb703264ae173e1aade0f6550aead06774"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ceb152d9aa81324871bcb61dd2ca1f477df6a51e31fb2759b86aad056ef796dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c990f700fbdb28f7552a1ef8b15a5912170cc200814c182bc286320d89073c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aff93a4f02dd324bd1917959d0bb0a4724af94430d9c5a22df2c67dce1439c45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7a514c0d9ad6c271f7e774ce05c63d67fe64b81522956d65f5d387a5fd7ebb2"
    sha256 cellar: :any,                 x86_64_linux:  "19074c63ac75ff8aee25d418636c674ab194d990e7b03d57882df5e277938062"
  end

  depends_on "go" => :build

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
