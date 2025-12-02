class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "30dc2fd5627ca29446dff807bc741cc0ec3bfee0a54c9cfd466f55ef29f2d1a2"
  license "Apache-2.0"

  # Upstream creates a stable version tag ahead of release but a version isn't
  # considered released until they create the GitHub release.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "416a0bb80d182b065605e7bf6a4b135d10f0fb6d2d5078157b122d47ea0be8dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dd67ad91dd21c5ee07720145f275a4e9dd9173cfe1db601bc9d9081cb1f5614"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1fed3562ebc90a810d5406ee038bd58d7684dca72cc2422aeaa30ac87af4952"
    sha256 cellar: :any_skip_relocation, sonoma:        "79635a67a55420342ed10f283f64dc28e8d2cd16916e38911c8b2b704174c833"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7eddc766661370c2cea233ae3430493b0f3597b28c14e707e10ed2734c5bc8ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a175610e2b5aedc1a5f183a6f65f20fc58b2431a39eb60ce66b16dd8e0a589a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=v#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: v#{version}", output

    output = shell_output("#{bin}/epinio settings show 2>&1")
    assert_match "Show Settings", output
  end
end
