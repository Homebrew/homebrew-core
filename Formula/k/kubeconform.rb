class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://github.com/yannh/kubeconform/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "fa5f1f7de0d6cd97106b70965c6275cc5e7afb22ff6e2459a94f8f33341b5c93"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f655b26950605b0d0dd78aa1e36f59308c2f8247a6fd03ed07d410d6ff745114"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f29d2ec9286b0b3da63491cdf5ad9a980e02b34c633922373d3d83c99a519156"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3dc75a32613607bcfda5b26e7b2ff438f6c2dcfeaa0253260ee3d769acd9846"
    sha256 cellar: :any_skip_relocation, sonoma:         "5209ac5e46f89e744fb58bb6cb5ac41f9afc2aff85debc3e087a22474058294b"
    sha256 cellar: :any_skip_relocation, ventura:        "8fabb1f54900b8f01c505683d3d6d5fc9818301d7d0fc73849ba9b9d99e32490"
    sha256 cellar: :any_skip_relocation, monterey:       "6a32ad8ac259fbfa8661ca05b74c6594bf6d5b95c853d76f9ccea4eab3c749f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "877cd8d28b144933a9ed71a46621654041bbdd86af88a282260e7825a8f58b2d"
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
