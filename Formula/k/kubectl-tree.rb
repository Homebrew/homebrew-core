class KubectlTree < Formula
  desc "Kubectl plugin to browse Kubernetes object hierarchies as a tree"
  homepage "https://github.com/ahmetb/kubectl-tree"
  url "https://github.com/ahmetb/kubectl-tree/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "480c71b07f27e5c824367e328c7c1818b76766a990a3a786189b698a7f923922"
  license "Apache-2.0"
  head "https://github.com/ahmetb/kubectl-tree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d829de1df35abf4ea5ce8d5e64f154178ac7b87aba4fee8ee3e41e85086b3ecd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2838060155814070f9d9d63bad3a1a9bddd27269de258ab398cc0570fa3883e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d6f00d76a3d2b714f0d9b54c62faa22249b505150b0680320a7337a6552c398"
    sha256 cellar: :any_skip_relocation, sonoma:        "25086a527e3b8ef3cb382a316ff9cbe06c4a212c81f6c8fda72e5766320f38d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "921484062c94213f86ac765fe82d20f27280ab182285186a8ca85d1a80052741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de85af9f5a8baa922b8664e71502227c8d0b70abdf254412bcf08aa26f2bfafd"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kubectl-tree"
  end

  test do
    output = shell_output("kubectl tree deployment -A 2>&1", 1)
    assert_match "couldn't get current server API group list", output
  end
end
