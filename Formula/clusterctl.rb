class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.2.0",
      revision: "aebeed871c780cfc71bc292dd59eed381da0771f"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "main"

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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5182d0a9f1a2234a9107c3a9ad7dacc931831196cbde5631971e645f96dcc68d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2470c4efc88af20afd2ec43262084232e304ac2b12820d97320008d4fb346d22"
    sha256 cellar: :any_skip_relocation, monterey:       "961a88ce875df11f359372de5a236edff043090944cfc6004ffa34095a5a151e"
    sha256 cellar: :any_skip_relocation, big_sur:        "dcb3382e2c085f6cf32bea422ef0913ef0bfc0f5afb2005f4c153326749bd89e"
    sha256 cellar: :any_skip_relocation, catalina:       "d5a79491b56b15f1aeba5a280d498c658bd0b684fa3c00926cfc57bb577c96d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d3af136f7fb4f7ab9414db88e4ef0f03e43fab3d52175046c4c91b9f20e4843"
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
