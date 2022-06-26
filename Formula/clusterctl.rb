class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.1.4",
      revision: "1c3a1526f101d4b07d2eec757fe75e8701cf6212"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f85ae7aa405ee3c8ddef8000708357870ce69e30a37667db8ceeb9a934c37657"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c173d1d7e84238f1ac8feb4c167951c6bec77fa3a5cecdb00f4f0143426c97a"
    sha256 cellar: :any_skip_relocation, monterey:       "1d8590ccf9b7a00e94687c4fc8a4ab2e21066dd39b3c784488f8e43f75cfacc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f368cfc3900bd81412fdceff514fabe62edd84d66c5db043a8c465b817a8d2b"
    sha256 cellar: :any_skip_relocation, catalina:       "65f9223f220813c9fedc40f9c6157339eafa6c4a3a9a212353fb6bd6fda97a05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcde88c8bd3220bfcf56489128f6a6a4231f3f3ae1e0b6ae61d4a9c470f40263"
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
