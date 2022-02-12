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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a91c5e08110ce13c641fe31182f41ff40edb9e296fdb292bbbdc186a47dc0f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6202662489b518fbb059451b5f130ddff07175f9bdecaf33d540b7002c4f5ac6"
    sha256 cellar: :any_skip_relocation, monterey:       "c7861d94e7d35cb9648657eae84252555b5a8134432b46338071b9981b0eaf67"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bf98e473fd1ec3f4dee1cc074ea712423d14743a593726abad0470d13ef3c7d"
    sha256 cellar: :any_skip_relocation, catalina:       "a1c1ec91ad9d147423e81d21fce2e6d8109da921df82d11ebb1b189764146b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea63dfae00e68d75a0aed2ee12f07cebc99eb9c411afe602445d67d879ca8d72"
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
