class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v0.4.0",
      revision: "7f879be68d15737e335b6cb39d380d1d163e06e6"
  license "Apache-2.0"
  revision 1
  head "https://github.com/kubernetes-sigs/cluster-api.git"

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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1cd736fbf5ae70d95d688cbd5c4b7ae6ff5298fe8e70799ecec308fe3fd450b4"
    sha256 cellar: :any_skip_relocation, big_sur:       "78f9971863e00fac134bb9aa6f9f4d27828917b8d5027bdf3970e6ae9aaf3c6c"
    sha256 cellar: :any_skip_relocation, catalina:      "9ae1266f24ac1d8396f47ff89437b214d15258858928ae2a2cb8125642a92600"
    sha256 cellar: :any_skip_relocation, mojave:        "f96cd10f55929c64023a498da32c066752e723b37db6d8a91fd64d3139555936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb4ffb94b1f1f435b61ab80f3f61103ff48f4ee84d46b9942106aa061696e3cd"
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
