class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.3.1",
      revision: "a9f75adbe9661f71f3980f7ce597bcb27d0e254f"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08b1b3ac03720d12cc7b742af4ac1f19655d555d9c21581d8a4a84274b22bc10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a1a4ad63dc24b04dad8ebb9f6cb28e6a36eb1268ca4c815ed6b96fcb9bdebef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d10fee7359d462be79ba15f1cd85ff488c9a31839850de25bea0701df375f70"
    sha256 cellar: :any_skip_relocation, ventura:        "f785e18f10429848af0778724a838976cee226a81f9e1be6ab42cf4bfaede05a"
    sha256 cellar: :any_skip_relocation, monterey:       "af4b577f4552efdb757c90aa959538fb64784315e0731427705e44aca59e3633"
    sha256 cellar: :any_skip_relocation, big_sur:        "879a96f0cd53502617335e312c4faf7cb669600cd9cfeda34572f18b625672b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f98debbe2b845fc1d1a8bb60abedb649754313a8981b0b54d44f3b6e6325adb"
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
