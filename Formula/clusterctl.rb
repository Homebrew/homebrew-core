class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "af60c8aa1b21eccc7f272c0135ffaf1a8e0ecdffb4173075efac52509ce0eeb0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "20a813817660bfc45c70d01fec814fa1155febbc6d917e3c55d8e058ea0a2603"
    sha256 cellar: :any_skip_relocation, big_sur:       "fce4aed624f692146b54755af147e3b40b97226aec1bfe7cef36752b67dd0ef6"
    sha256 cellar: :any_skip_relocation, catalina:      "ee868f60877c705914e9db906b1990c33d35aebf91db26f4e65117087cc6e66f"
    sha256 cellar: :any_skip_relocation, mojave:        "8a1ed5fbdf08a7928612a5dfb0d6fd082c013b03f552fdc51728b70df5dc827f"
  end

  depends_on "go" => :build

  def install
    system "make", "clusterctl"
    prefix.install "bin"
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end
