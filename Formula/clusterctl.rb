class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v0.4.1",
      revision: "f6fd5ed7dc0fa75788f76f17c64ae82976fcc70b"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d4fec53cb661771a6dcb2e4f2e3c860a79656a120ed332a1c1555998a3e27a3c"
    sha256 cellar: :any_skip_relocation, big_sur:       "fb2e59764b383900968a5193c3fbc7b797c5c5722bdb03a3204e5f5d7640fd3e"
    sha256 cellar: :any_skip_relocation, catalina:      "7f74e4c464c11673784f7331ed832b30f7006e0cce38fef385e630d09b84e995"
    sha256 cellar: :any_skip_relocation, mojave:        "6f5e794cab422d4cfb2550d1b4ce82cfe0ea7d0ecd9cebe5959dc9500103a72d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dae7988970564497806f8e0daeb5d0c50e337b95301507f559a392ae10d2470"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "clusterctl"
    prefix.install "bin"
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end
