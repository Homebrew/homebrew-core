class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.1.5",
      revision: "d488bdb875d302eba85221fa35c9f13c00df4ae7"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af4e8dc165be54703b7c5a8f5df436d2f399bc6a3aad64769ae305715fcc7a7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a36a1c230424be6e4042aaccde4fd9721141fee2f93367922ce3b149c9a4f498"
    sha256 cellar: :any_skip_relocation, monterey:       "5eec16e3eac37a9145fe75e9ce7f9357747a7cda5ff1af595890e1648debb973"
    sha256 cellar: :any_skip_relocation, big_sur:        "63cf203484eac53392a04cf4db083d93394513626c283415b1c68819a3fd7af6"
    sha256 cellar: :any_skip_relocation, catalina:       "e58214c2d67a4b52a452a0c2cc06451f3eae8d9a181881c4b60701db46ae3bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8bf080903fa6ca8058a2c2784e6aee5418724251dd5ca91437be86924a773e5"
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
