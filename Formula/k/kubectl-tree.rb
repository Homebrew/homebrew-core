class KubectlTree < Formula
  desc "Kubectl plugin to browse Kubernetes object hierarchies as a tree"
  homepage "https://github.com/ahmetb/kubectl-tree"
  url "https://github.com/ahmetb/kubectl-tree/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "a2c62e887be6bd66c920edb26f9e8ad40d483d4d257e31641fbbef8f0ab1a6ce"
  license "Apache-2.0"
  head "https://github.com/ahmetb/kubectl-tree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8c9c1a1c4e2a65ea14c2d7f9990bd8f2fe6c8e3e830919ad640c869e166d046"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45fd6b68d10fa64ce250f52d574634672c210570ab0b0960a9c84ce42178efa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dcd520acf245e481c48b5c08af866a78d69792e4ee18c6f60ae6f14e8a13885"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba008a72584d6be183422f3d988b35d26141745bcd05d00e0154d637d80f63b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "224504e2c9fd2de41560172c879f24176d6121fc007c62d2793f9956a271d225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a4a5b3d0e76566295fb81859c31ff111b4329a22b147fe1be68a6063abe4ddc"
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
