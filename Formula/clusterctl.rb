class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v0.3.18.tar.gz"
  sha256 "8ae5b7248f6bc04a1ba6965de51a191982d74ecc150c92b75c35f3b498543d8b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "39ec05bbe8601c6c706f29a35d94866d18c38d08b1c23cdc84a13249a479c261"
    sha256 cellar: :any_skip_relocation, big_sur:       "0d6c3d173ec5c9142a77817ad28ef9bd4c9ed90a47fc7f96997b0c889c3fc7be"
    sha256 cellar: :any_skip_relocation, catalina:      "331eb8fbdeb00cb64d928e785142a0d67ce5d0f83c47cc6786bdb2bc4f601578"
    sha256 cellar: :any_skip_relocation, mojave:        "81e8c95f41c74e6e1dc275c39ca4fa61714fc0f2d90e220e74c40521c16e4551"
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
