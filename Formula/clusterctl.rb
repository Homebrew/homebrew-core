class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v0.4.2",
      revision: "dd8048ce988bd7d7ab6dce760c2ce12e06c2482b"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "master"

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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1702a4443b1d310aad17c7c98c9c96103a34d13907d108b24165780666adf840"
    sha256 cellar: :any_skip_relocation, big_sur:       "3e007450ef2d4160cba85aef287d7528cbc0532c3fb4ca06b07632223e6c9c27"
    sha256 cellar: :any_skip_relocation, catalina:      "b1e72c3e6048162ab3d0a07b2f358cabca7f5b09a2655484af88ed5f00fc1cd2"
    sha256 cellar: :any_skip_relocation, mojave:        "700092086903c9df8e0d4bbe89a5be1ba94671057261de6d0f15f6489fd8e00d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07c64e9f9eb9e253faee1b12095b2f80b780bfc0cdbd7d5edecaacd8ba464396"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "clusterctl"
    prefix.install "bin"
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end
