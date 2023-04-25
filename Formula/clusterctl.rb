class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.4.1",
      revision: "39d87e91080088327c738c43f39e46a7f557d03b"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "main"

  # Upstream creates releases on GitHub for the two most recent major/minor
  # versions (e.g., 0.3.x, 0.4.x), so the "latest" release can be incorrect. We
  # don't check the Git tags for this project because a version may not be
  # considered released until the GitHub release is created.
  livecheck do
    url "https://github.com/kubernetes-sigs/cluster-api/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2e51f746ccc28d27c7993da922fe59e4b3f3e5f772e885bcf0ef0da9b8d34b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18a23d42fd359b28c7097ebaeb7e44cab2f839139f1143de5ba52535c1b7a496"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2e51f746ccc28d27c7993da922fe59e4b3f3e5f772e885bcf0ef0da9b8d34b9"
    sha256 cellar: :any_skip_relocation, ventura:        "99ea9babd92ffb477714cea03c0e8a5017ee5dd5e1e9f82bfc49868fccd3e288"
    sha256 cellar: :any_skip_relocation, monterey:       "b3be75c8efb2f775b2eedddbeb71f21c51d58e553bf0f7d1cafcc7fd25345790"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3be75c8efb2f775b2eedddbeb71f21c51d58e553bf0f7d1cafcc7fd25345790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e93def2f24cb6c21f0c6a31d869db245ab3a86030be2fdf2798339587121869"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "clusterctl"
    prefix.install "bin"

    generate_completions_from_executable(bin/"clusterctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end
