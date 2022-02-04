class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.0.4",
      revision: "e52c151433b43e2ccfbf7a1b95cd085810c207d3"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55b45d316f2c809e5ce93db122b8347c08598386d73025ef50a41c6ede62e6e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "223f03217946a9a0a8a6399be534982ca43933c76e5d1df14202b1cdea35c60f"
    sha256 cellar: :any_skip_relocation, monterey:       "dd52d074df9d73a8b3df289448b9df30d99a22d74fa94b9698c4ae9995f5210d"
    sha256 cellar: :any_skip_relocation, big_sur:        "546d5d94e76578fb63fad0acea6bd4c6fd4f4cfab5b09e47270ef47bbed72cb4"
    sha256 cellar: :any_skip_relocation, catalina:       "5df54c6b9cb8d8771fe9145492716221776f69cfe8bb8c7ab51512f552fd5989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73829567421289a48eb898349e9163091bf1ca1bf0ff9eb697df5514196464d9"
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
