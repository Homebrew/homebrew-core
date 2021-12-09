class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.0.2",
      revision: "89db44e9a462028267ed49295359fe9db2a6a10a"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96c367c28466aa43f1a577125746ca4deda9255424450169d5ce8fb2bf127b21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a7e38de66ef3dd64901b3f6ddbd6b4c6765d0c6449e7da43d3101cad9cd0e69"
    sha256 cellar: :any_skip_relocation, monterey:       "c160d942e3fb67a072070274fa84aecaef27f35a1bcaf11ce8a2d48779ddfdb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3d8e364efb5a6b159b21cd985584071d9d306e288cc006625c5d2db18879b35"
    sha256 cellar: :any_skip_relocation, catalina:       "d3414a8a100bdfdcaf60e3680cd18af16266dcc4702aabefba41ad9d0a55e07a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3dca2997eae33562d0f94141942c50a37c0d30bba7a8121e711ec0cb6ecfea9"
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
