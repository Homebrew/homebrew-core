class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.0.0",
      revision: "e09ed61cc9ba8bd37b0760291c833b4da744a985"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "77b826c471c6bb21aa8ec7687d6d2f1b1eb072c550a46cbffc67476bea58f87a"
    sha256 cellar: :any_skip_relocation, big_sur:       "62e5c9130d33aea0f3b9966513a1f10b8647bdd3a6754bd8288901b4f72bf452"
    sha256 cellar: :any_skip_relocation, catalina:      "20eece87ef7390495a2dac28245044e54db8417b173f2291f4d91a2df06829ee"
    sha256 cellar: :any_skip_relocation, mojave:        "2a1efe302813114404bd9fb06ecd5769d3819127249b396a828621d61e3786ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c5d48af679a9cf99d2628d4b87429f461d76e9e3ff6a7d365d12a89e040e863"
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
