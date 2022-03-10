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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b01d738c5106272f4c10903083efb0d225977f71abeb98d26855e78afa41bbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "272eb130df23b35adab10eef8c0a72e81ac4f4eca61452ce65aca4aba775a2f4"
    sha256 cellar: :any_skip_relocation, monterey:       "b1997d36961276f558d41119e6e577293129a555892c12e9989671c4d3a85b32"
    sha256 cellar: :any_skip_relocation, big_sur:        "92926a5d200d730eeb3a43af2f30c36b46d5f3055739b755991fff6a19bb2976"
    sha256 cellar: :any_skip_relocation, catalina:       "2d35cf28126ce25bbfa2cc9a3512aa75dfd65cb17b9e868bfbfc1cf680942e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d308e545ce743ab4a8155dfce2b64522fdda3bf1f1fecb2cef825b38e5437bf6"
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
