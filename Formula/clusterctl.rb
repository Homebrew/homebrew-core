class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v0.4.3",
      revision: "a3e4b37c40ef8bc8ca1748fecb9b98c88b868e1f"
  license "Apache-2.0"
  revision 1
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "829637298f493982bdf4cd8df7d96ee90d3463cb18c0d77c5765e554de14b47d"
    sha256 cellar: :any_skip_relocation, big_sur:       "d3bd4aedf579ec1488931c0609e6c0d72a2960adbac711cc5fed24f5641ee228"
    sha256 cellar: :any_skip_relocation, catalina:      "77e71abd384aa26df007362f228e6ddc83ae68ace6d195acc68d765d6cf42934"
    sha256 cellar: :any_skip_relocation, mojave:        "30e51d3b972d24102cf04bc66c6c39e2ce1362b306f17f4462bc74fc245728a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec55e3038cd8f87f765598d21d6b1b9b1da18105f6290017a9cfd3adcfce1af8"
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
