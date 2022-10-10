class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.2.3",
      revision: "bb377163f141d69b7a61479756ee96891f6670bd"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b122ade1ef5cdf74cc5f0e7859f60acb94f9b65fc7875b2061949c51ff1945f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bffe7e045e893dca9bfb3c3dff77a3c9bfb7a9781fbe4755fe4538dc2aec2897"
    sha256 cellar: :any_skip_relocation, monterey:       "23c591f5f31b49c3dc2bf0d21233b842932a61e47bd8c21b2f79333e8e0af42c"
    sha256 cellar: :any_skip_relocation, big_sur:        "059cf6f88b5fa72da50b837ab5ea68e42fea58dec03141e039c1c4e6c558f379"
    sha256 cellar: :any_skip_relocation, catalina:       "a62d092275481dd516259002228f28a0dd540937e7dc455ec4009a56066dd224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b33df6bea91e1407556628a2ceae853b63e9e8496203d220fbf0e7c6662dd389"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "clusterctl"
    prefix.install "bin"

    generate_completions_from_executable(bin/"clusterctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end
