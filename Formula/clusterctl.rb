class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "af60c8aa1b21eccc7f272c0135ffaf1a8e0ecdffb4173075efac52509ce0eeb0"
  license "Apache-2.0"

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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d7dbe58662801cc61010395c0ab0599bf41f0f66ecaa8a2a2edb0dc22695df5d"
    sha256 cellar: :any_skip_relocation, big_sur:       "86cc35474c11ea9869cce7b4c6aec6eae2d71f1cd334b08576a9dbe8dc1cdea2"
    sha256 cellar: :any_skip_relocation, catalina:      "fdacdcc5c272ce5ab9bb84ec0dbb3560888221072aa71fde46fb280cb33be621"
    sha256 cellar: :any_skip_relocation, mojave:        "6f97b2dcdbbd79194265ca46715f7bc6511acd9a6db4ee33496f7fdf8baa0f82"
  end

  depends_on "go" => :build

  def install
    system "make", "clusterctl"
    prefix.install "bin"
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end
