class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.6.3",
      revision: "965ffa1d94230b8127245df750a99f09eab9dd97"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "main"

  # Upstream creates releases on GitHub for the two most recent major/minor
  # versions (e.g., 0.3.x, 0.4.x), so the "latest" release can be incorrect. We
  # don't check the Git tags for this project because a version may not be
  # considered released until the GitHub release is created.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9df76a31154ad6d617b4c7b2c10c9728067d2096390b46aacecd1bde46e4173b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0376506724254b4e43a323a871243c93efb6b718c233a33c5c647991c070225"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9630d8487f0af2a936a74c3856ba954ca74a0837efb7e440ede1119b86d1c229"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3c12fee63190ad33b1657b3c04631bb0147130e7ccead37d8b6b2ce9e191f5a"
    sha256 cellar: :any_skip_relocation, ventura:        "9abb425c51df636abdbf89ef54dc5f0a9bb51ec0df07deb784acb65e50abee09"
    sha256 cellar: :any_skip_relocation, monterey:       "cff01ecc85d85be66311066bc83d7531db6e0743f8ee990a5a37ca481e8f831c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d3e0dfb68c6e574f6511894a4d5ae1eca7db4538cca3450830a46af1b9b6b80"
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
