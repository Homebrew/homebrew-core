class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.4.4",
      revision: "00dbf7b9f6322d7ebd06ae2efa703b23354dd37d"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcba16afc20e78881001830e1a6467867057b5a1d8ecaec3d3048caa6d518ec5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcba16afc20e78881001830e1a6467867057b5a1d8ecaec3d3048caa6d518ec5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bcba16afc20e78881001830e1a6467867057b5a1d8ecaec3d3048caa6d518ec5"
    sha256 cellar: :any_skip_relocation, ventura:        "9343b689095dab2298987e1a45477fe939a145c7185a6156f2b80c060fd0fa31"
    sha256 cellar: :any_skip_relocation, monterey:       "9343b689095dab2298987e1a45477fe939a145c7185a6156f2b80c060fd0fa31"
    sha256 cellar: :any_skip_relocation, big_sur:        "9343b689095dab2298987e1a45477fe939a145c7185a6156f2b80c060fd0fa31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33e0bdc3a7f03a52329858156c0c54d6e597faadb181dfc4fa3ea7ad4f300854"
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
