class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.3.4",
      revision: "26d03d29435305555ca9271fbe26916a37c43e11"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "144dd5d6f737c7bc8c9df8e212577c6440ced9fff82e2360715579971dc1d916"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d16e1ca3e300ab44e43ccaaae8f6e4825d551c0fe4e45c8f654a9e04d14c1ec1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a6fa7219ca24f770d91df0f8088a1cdb5a60aac078702cfe1b98d8158b1bc27"
    sha256 cellar: :any_skip_relocation, ventura:        "4d4660959c1f265a6c7018033983e3f639bd2d7487996af830457b0aeceef13b"
    sha256 cellar: :any_skip_relocation, monterey:       "04e0976b880fdab1979f4be5c3a297394ac683ae68e5a492d3b1a2028a0faebc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6951ea8f500cc03612e0e2d6e335ed9f356ce3b101aad5902a741f9f887afd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8afb81cde92e599e011629cddb83a2ef7015c0711f7fcb4ff48fd897f40bb4fd"
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
