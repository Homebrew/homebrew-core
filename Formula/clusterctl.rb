class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.2.6",
      revision: "6f61373d9f32c32e62def4140bfc6becee46732b"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1db2c828388b1c43797f13b8ab0e4aa75349af81fb574c9f00dc530d384a9f1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81d1235770e53aaf369dc98319779168b2cba56be5f62aa18e636bd692fd7fac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "830138be249aff359e0b60c3b2aa554959c2a265d2d7a4be3d3291c99983ff3a"
    sha256 cellar: :any_skip_relocation, monterey:       "ed0fa5adf93827a92a3dc2ede38aa103a4af08a6485807820ed73e82b0fd3bbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5cf460f43ca5b18f1afd03b257ac195b21404ea88fe6f564efb7cf9fc82db39"
    sha256 cellar: :any_skip_relocation, catalina:       "6f2404305477abdf75d1bc34209f55a601603a38e7f1e392d30ad4a72c68a765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a27b4adaddae82415462db1bced6304a86342d118e0357585e86ec00209772ed"
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
