class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.0.1",
      revision: "2887be851a4384bb000d2a498099f96fe0920cd1"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaf063c677488061760af71586afbebb544c0bd5a750b06599d0ff88f1b1d9d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d0ebf5fcbbdf8bec2e3df46bdbb580894bdba64a5677ac83d4fb7e6aa70a88a"
    sha256 cellar: :any_skip_relocation, monterey:       "25cd16eba534e02ccf310662ba5e8a41cc2ca67da99ccdd6817e380329880a36"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd76e3184ca510fdd3eb0207b387918e06f8e91490977b8a35ca9bd31180c766"
    sha256 cellar: :any_skip_relocation, catalina:       "a40e719b9171970ed87501a59b9d31f36f17f463e6bf7d3cd0b0a693bb424abb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff7cdb536ffdf14e1b21e9f9048116969ea8cef3b1fbc4311965df7c4d91d050"
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
