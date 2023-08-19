class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.5.0",
      revision: "4abf44cd85c4590602e4c10543d53cd4ec914845"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "main"

  # Upstream creates releases on GitHub for the two most recent major/minor
  # versions (e.g., 0.3.x, 0.4.x), so the "latest" release can be incorrect. We
  # don't check the Git tags for this project because a version may not be
  # considered released until the GitHub release is created.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e62bf4a36cf258863f9f42a94d94f18cb7c4043f2f84ebd491af834b76f7a4e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa8bae7ceea7b9dc5a340c0011b4de997ec0e2ee4c1c5f63479501b87f2a3d75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "450ab2cc8fea31d0980eed9351639f5d0ab66ad5dfaf0b3d5ce4710a58aa621d"
    sha256 cellar: :any_skip_relocation, ventura:        "6295b5671423be369592cd78225727dcb094a7896414ea67368cd05eb5bef2c3"
    sha256 cellar: :any_skip_relocation, monterey:       "b398d6ea8871812b35e6b6f16b13a3a19c7d50b9f3cb1724bdba0535fbe355c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec0105359dd83eecfaf3e036cb499667c85ee5122963bf5319b021038e9e1b2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "388fc96a9110cc1b51f048fa21afbe3f5802a9d6c9f4e366fafc68a9bdace8fd"
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
