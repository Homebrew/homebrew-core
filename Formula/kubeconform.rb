class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://github.com/yannh/kubeconform/archive/v0.6.1.tar.gz"
  sha256 "f9bfb47cbf5346d96330e2389551539329340ae68e4a47c4e3fb9b627750c9ef"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bfd85a40f735623db1d3fdfa2482a2df04b2b8cb0674020a004f3b6fc95264f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bfd85a40f735623db1d3fdfa2482a2df04b2b8cb0674020a004f3b6fc95264f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bfd85a40f735623db1d3fdfa2482a2df04b2b8cb0674020a004f3b6fc95264f"
    sha256 cellar: :any_skip_relocation, ventura:        "f3d0bec319dcb7e561a8b5fdcce70f68657f1e5f073b11335bee55cb882ca2a0"
    sha256 cellar: :any_skip_relocation, monterey:       "f3d0bec319dcb7e561a8b5fdcce70f68657f1e5f073b11335bee55cb882ca2a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3d0bec319dcb7e561a8b5fdcce70f68657f1e5f073b11335bee55cb882ca2a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4c38913edc104275a4ac622c73b4ea0b9567221625ae468653ee6596dc494d0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kubeconform"

    (pkgshare/"examples").install Dir["fixtures/*"]
  end

  test do
    cp_r pkgshare/"examples/.", testpath

    system bin/"kubeconform", testpath/"valid.yaml"
    assert_equal 0, $CHILD_STATUS.exitstatus

    assert_match "ReplicationController bob is invalid",
      shell_output("#{bin}/kubeconform #{testpath}/invalid.yaml", 1)
  end
end
