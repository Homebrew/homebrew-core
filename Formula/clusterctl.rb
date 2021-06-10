class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v0.3.19.tar.gz"
  sha256 "03122ac06ec7b8dfd517f5c93d355fc967dd4550aeecba9fd734addd7fed2f7b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bba5f5b36679c99d98ff5bb88fefa3c5b2989f99e71482f67e587ddf62238a17"
    sha256 cellar: :any_skip_relocation, big_sur:       "3b0f5c3ff6333687ca5f81617e6e05b16e0f49b678f4a2c7ef4acd44923faef9"
    sha256 cellar: :any_skip_relocation, catalina:      "5d2ab997c76b6ff2fadfefcc32c94f94ff0ef57aaff98a5a5e07db208b44b508"
    sha256 cellar: :any_skip_relocation, mojave:        "f2ec07a48f69bbd812acbd53768ec8a0da5ab090fe493a899c10a48555e6ad4c"
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
