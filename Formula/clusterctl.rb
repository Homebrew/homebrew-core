class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.4.3",
      revision: "14b88ca091102b72c591cb0357199834385df478"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "main"

  # Upstream creates releases on GitHub for the two most recent major/minor
  # versions (e.g., 0.3.x, 0.4.x), so the "latest" release can be incorrect. We
  # don't check the Git tags for this project because a version may not be
  # considered released until the GitHub release is created.
  livecheck do
    url "https://github.com/kubernetes-sigs/cluster-api/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b5959fca661ed1b1c365e3df1e73a7b85060c815395c05da744aeabb1a9d292"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b5959fca661ed1b1c365e3df1e73a7b85060c815395c05da744aeabb1a9d292"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b5959fca661ed1b1c365e3df1e73a7b85060c815395c05da744aeabb1a9d292"
    sha256 cellar: :any_skip_relocation, ventura:        "ea76cd4527ab0c5c0f393e345caeaca79b3ad8eea99be22545a5adce0ee23b5d"
    sha256 cellar: :any_skip_relocation, monterey:       "ea76cd4527ab0c5c0f393e345caeaca79b3ad8eea99be22545a5adce0ee23b5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea76cd4527ab0c5c0f393e345caeaca79b3ad8eea99be22545a5adce0ee23b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fb8dcdbee11d34d0bc46bac79d6f5015ed164112ca5b25966551a16cd8c730c"
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
