class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.3.5",
      revision: "58770484dee6c99c10e32c06652e9f9643f78e9e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa1ddb987b10d0df6e8d51cc9e100977b6c538123d2b2c062f4018804e9407fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa1ddb987b10d0df6e8d51cc9e100977b6c538123d2b2c062f4018804e9407fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa1ddb987b10d0df6e8d51cc9e100977b6c538123d2b2c062f4018804e9407fa"
    sha256 cellar: :any_skip_relocation, ventura:        "225d61c4e0bf132e705daf07c47994c90f4d1dfd2e67ac07f38f1b4bbcfb8fa1"
    sha256 cellar: :any_skip_relocation, monterey:       "225d61c4e0bf132e705daf07c47994c90f4d1dfd2e67ac07f38f1b4bbcfb8fa1"
    sha256 cellar: :any_skip_relocation, big_sur:        "225d61c4e0bf132e705daf07c47994c90f4d1dfd2e67ac07f38f1b4bbcfb8fa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c803b8956551de23aee81009d37fd64dfc151ae78dd0d5796e4bf9e37a57665"
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
