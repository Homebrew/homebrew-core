class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.1.1",
      revision: "810c2a67e71ed3344a29ae79862407d6b0631a79"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "master"

  # Upstream creates releases on GitHub for the two most recent major/minor
  # versions (e.g., 0.3.x, 0.4.x), so the "latest" release can be incorrect. We
  # don't check the Git tags because, for this project, a version may not be
  # considered released until the GitHub release is created. The first-party
  # website doesn't clearly list the latest version and we have to isolate it
  # from a GitHub URL used in a curl command in the installation instructions.
  livecheck do
    url "https://cluster-api.sigs.k8s.io/user/quick-start.html"
    regex(%r{/cluster-api/releases/download/v?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbde8f47aa95534c08dbd09b07712773a45e76bc648bb6b820dcc6974253badf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9966382a03c55c887b7502404a933cf5efb48c6224d271af9ee2d2756f3a6ba"
    sha256 cellar: :any_skip_relocation, monterey:       "92de55a7d462350a03fec60a2717f50f7d9f18efab12596a37ff06915c3a38a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "432b81e21150af13dae71cc6b04ee931709c3432e6932b1ebb66920fb30d7a6f"
    sha256 cellar: :any_skip_relocation, catalina:       "485883ec369fcd49a210055f8dc33ea4e7d386957cc8ec5ee15d38573e23b200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc4e59cd8938bfb48e6291fdeb25c12d58a2165f82bf6b6b6aee60c0de8f464f"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "clusterctl"
    prefix.install "bin"

    bash_output = Utils.safe_popen_read(bin/"clusterctl", "completion", "bash")
    (bash_completion/"clusterctl").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"clusterctl", "completion", "zsh")
    (zsh_completion/"_clusterctl").write zsh_output
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end
