class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.1.3",
      revision: "31146bd17a220ef6214c4c7a21f1aa57380b6b1f"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c8ba7b00181c13db9592164994d3154570583657dffd2c473827b28730f4d21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6641e562bdf429bf1e41610d7f91540b802903d13da04813ce595ea88d8ae3e"
    sha256 cellar: :any_skip_relocation, monterey:       "3340b3ba34bf01be75c24d602fc75e1d6c1811a965be0941c12f6099a5dfa91c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b02954f1cb9dd1592e9226bf1cd716728c28433fbd4e89ce7dabaebd7d2653f"
    sha256 cellar: :any_skip_relocation, catalina:       "b9972c435d1c51ec92962f55cdfbcb625bb34c913f64e5bf2d1db13ed0882d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "920c7b63d559a0daa5513ac3d34a0562071a59205c433f0f4789126094ab46df"
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
