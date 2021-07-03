class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://github.com/yannh/kubeconform/archive/v0.4.8.tar.gz"
  sha256 "359b9c81733e93f32c0e73c95170773b9cc92ad2bbebdaeecb236d8bf9114440"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bbd290a66a1e16396dde64e9f0b639b175dc7f12911ef81ad59590bff36b2fb3"
    sha256 cellar: :any_skip_relocation, big_sur:       "f0c3ae03b3f4f7f1a96b86d07406a9f55ccc4524279be707831bc9c6f4282a03"
    sha256 cellar: :any_skip_relocation, catalina:      "da7c83f396b4d3a7ecdf86db2889a4af5698a83d51c0097aa4ae231951be4771"
    sha256 cellar: :any_skip_relocation, mojave:        "7d0cd77dac537693225ae5e26e2849fbdba6028e8ce42a1d78af15e2f5c1caf0"
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
