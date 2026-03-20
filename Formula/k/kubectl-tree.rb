class KubectlTree < Formula
  desc "Kubectl plugin to browse Kubernetes object hierarchies as a tree"
  homepage "https://github.com/ahmetb/kubectl-tree"
  url "https://github.com/ahmetb/kubectl-tree/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "5b0070fc84fa54e4120a844e26b5de0f5d8a9c1672691588f1fa215f68ba1e5d"
  license "Apache-2.0"
  head "https://github.com/ahmetb/kubectl-tree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3c10d52a8ae955a32d9226e50dce3a49dfb371c3056dc32160b81fdc6e447c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1005e06b3ddc5f3f033b74987380a2c0df81ce21977e4024b72c354fe5c60dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49b0a79a58a2bede20dfdb9ecb3ebdfcb2836b05599f65c52a47d8680a4587bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "68def8c7c63822e6ae448e35ecd293c60a99b9238da8e6ecf6cc17c9b2364dd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c580051105677ae70964420d948adcd9fa8176e70d1a1dd2eb78c26e16a96363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3814aa8afb541953b0497dce173a461b0da330b8c8c9ccd8eb1f7c3be36fe36b"
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
