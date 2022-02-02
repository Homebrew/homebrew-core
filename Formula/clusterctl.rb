class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.0.3",
      revision: "b3bd6cc9c6525f166441ff2635faa48e60884a51"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e22efb1accb8accaa0ab283131b2adedfe2d772764edd44948800db87cfb20a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ea3edbc610499dc0e528d356353b365eccb49b62c62b2badfe176710b6e4833"
    sha256 cellar: :any_skip_relocation, monterey:       "34bfbc92e043fd59e6f7c7b6d228361f9e16b37b998e7cbaac938e2424e388c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6251957fa9f1a5ffdcce1469adbfd0f6658ef44ceaeaa577d3940ec84e82a3b0"
    sha256 cellar: :any_skip_relocation, catalina:       "ceef75736bcc3deda414b5e5c41ea3f5bd03a87e20473f7eb073100d1be456db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd51f024b7e47eae31d4a2134c84916c0dcdb07fd2cc861c68dadac39ef5df95"
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
