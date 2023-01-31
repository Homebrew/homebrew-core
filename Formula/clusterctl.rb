class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.3.3",
      revision: "09030092bf1e9891da4cf6b48b486cb76efaab82"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55484328865a33e06e3103acd574ffeb010ca2316c8aaba95ae1c8fa4eb35e28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5eaf2a0739b6069b26fe7fb33e72141ecce353b1c5266919d41e77acdbe01837"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53991b43d1881eb6df065dd222edfe8f59c6287af996d6364aed73f4635578ad"
    sha256 cellar: :any_skip_relocation, ventura:        "d7960d6335fdab995a171f82ed1813fcdc61ab780feae8771ecb879dd17b6fc6"
    sha256 cellar: :any_skip_relocation, monterey:       "ae4b92f5001c557971f616762aebb30e364fe4b49db743641f26872021ae8016"
    sha256 cellar: :any_skip_relocation, big_sur:        "72809a72aceac64a2c17521f7a476087926a8a5abd1fe0368d4512ed84cb3da2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65224fe2112b9f3a84e8b45a4f21e1094444dac856754c21d83bb46a79ee6d1d"
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
