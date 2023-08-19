class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://github.com/yannh/kubeconform/archive/v0.6.3.tar.gz"
  sha256 "66aa8eb5f3c69b7039c474da20b1f0d341e15eda4d9ef1853060ed0744de63fb"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c56f0c428d11b3973b53b4d6e5b5d0e011e1de15683801243137379f4390ef29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c56f0c428d11b3973b53b4d6e5b5d0e011e1de15683801243137379f4390ef29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c56f0c428d11b3973b53b4d6e5b5d0e011e1de15683801243137379f4390ef29"
    sha256 cellar: :any_skip_relocation, ventura:        "71e4c0065b18f84177a2ddfefb4f437ad45bde711569f1c3774f3616d08d441e"
    sha256 cellar: :any_skip_relocation, monterey:       "71e4c0065b18f84177a2ddfefb4f437ad45bde711569f1c3774f3616d08d441e"
    sha256 cellar: :any_skip_relocation, big_sur:        "71e4c0065b18f84177a2ddfefb4f437ad45bde711569f1c3774f3616d08d441e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55fb1548ea87d904ffedee4570f193eef48daca3b6b3e0ca6ee2783c78966572"
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
