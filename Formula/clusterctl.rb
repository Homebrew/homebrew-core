class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v0.3.16.tar.gz"
  sha256 "38924e4d386cf61e3761ccc5e0738bdc8b355c6281f81fc972b15c640a0a61ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ca3f4853053d72589f01c5b0bdda95804289bb8da7183a7d4cebd27c36d68777"
    sha256 cellar: :any_skip_relocation, big_sur:       "088ae26c24231585de6c7027357f3d654f15f338e3dddbdbf7a9b273889acce8"
    sha256 cellar: :any_skip_relocation, catalina:      "fdf4d76eac31c88b12c546157ac3a90c834aa03d84f90235ac418f8cdc3f8067"
    sha256 cellar: :any_skip_relocation, mojave:        "72a8443517ef0a44922b8200496c5d40e43e21d75b981064d2d1dc24e4776234"
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
