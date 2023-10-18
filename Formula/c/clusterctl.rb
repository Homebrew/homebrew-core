class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.5.2",
      revision: "3290c5a28ed28c1909713e59e5d481a3e8f68a90"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3b477afe88acb6b3c6bdd1e9dd294cb3dcbb571d06b784048c74e0a1d6239fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac802d88337866a7c8bbc90286ebd595fc26530130fedeb63ec3df598c1bd05e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "032e596fc1cc91ede99867358edf551a326deed77368657a9692feb275419a66"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e0ab932f7902bdfe134e9ba566417fb867987b83894a7853099e82fe0bc7864"
    sha256 cellar: :any_skip_relocation, ventura:        "e48b9e5a3a08a2d65d3d26dd49924ce1218ef91b5bfedeacb26e7f9e0b3fa6b8"
    sha256 cellar: :any_skip_relocation, monterey:       "1a8da55d765e686babff3aaec2b0d18efefdd284088779318ced72453ba44669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8359e4bcbf4be11ce1317422a09a5f08687b9ce67eb35c42641c842edda43362"
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
