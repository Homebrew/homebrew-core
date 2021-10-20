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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cf44da229fbd2190227c32fc830a13fbfd4c2ab218b3e404f058224a13332aea"
    sha256 cellar: :any_skip_relocation, big_sur:       "34607708549a05bff8c4144f2a1fd91cc0f6461322b2c299942e6b25a09ad456"
    sha256 cellar: :any_skip_relocation, catalina:      "25e082158e2f7ec8f5c248e4e409ff9c78e79f1753ce0ee9f30b698e638b5aa4"
    sha256 cellar: :any_skip_relocation, mojave:        "4d6a2d3e93b26cc928599c3c906a1c9418672e42d2199b12c8cb587662b603f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "096e35d1cc0e3180a4837badada836925041a5d7d2b731d86a04ae7c96618fb4"
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
