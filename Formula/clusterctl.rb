class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.2.4",
      revision: "8b5cd363e11b023c2b67a1937a2af680ead9e35c"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b2fc3019f2f930263959d0fa4227380807650b844cc61812f2f0b1743bb51c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3b0653a7022762a9cf9590781c292e0c701e4458f35334359366e5718047671"
    sha256 cellar: :any_skip_relocation, monterey:       "bd680598374e7cb05d904f7893160587ae119fa2adb72217ea21fe0544f9f2a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb2d4a21f56f04eca8117aa5ca34e01f5b8f4b53c0e02142af69973bd1f489c5"
    sha256 cellar: :any_skip_relocation, catalina:       "cee19a2c6bff2767645e318cfd0d843775734f3dd38b86ae1200175a21c5d0e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ec1b885e6b130bf7dee5e94e6bae9e486e63d0bf86c504882bbc773b075c2bf"
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
