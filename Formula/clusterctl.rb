class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v0.3.16.tar.gz"
  sha256 "38924e4d386cf61e3761ccc5e0738bdc8b355c6281f81fc972b15c640a0a61ed"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c9d431c82b44e2fbffd942cd109122c26647596bf1308f016ab91c1364af3313"
    sha256 cellar: :any_skip_relocation, big_sur:       "394bcb29c3a32b3c6f9ab6d2b307970f099ea6eab792c5f5238dad05be986b06"
    sha256 cellar: :any_skip_relocation, catalina:      "ffb6b062b6d1199b54de0f08ec2109f30994819b1ebf627f571e91b07ccdd816"
    sha256 cellar: :any_skip_relocation, mojave:        "bd04ca87ea4fbcb7a6d96ae0525701f9ce858775bc7c82cce063cbea50fd9e8d"
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
