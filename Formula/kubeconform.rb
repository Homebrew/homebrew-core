class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://github.com/yannh/kubeconform/archive/v0.4.10.tar.gz"
  sha256 "89ec81159540d73cc9de43a055da784dd226b2819debf247b7aaaf6bfbff9f7c"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5fa7f07d067c4df8e111eab2798d8c8a6ca7723065f129f439d35bc2b9f6c301"
    sha256 cellar: :any_skip_relocation, big_sur:       "c8ffc95322b81fb66750c6b14207605223e06912f833b7adbaef72e153168bd6"
    sha256 cellar: :any_skip_relocation, catalina:      "a7dd7127131858fe2156a3500a656c459bd14be2160fd042cedd70728b7f3dd9"
    sha256 cellar: :any_skip_relocation, mojave:        "7d6b9529ffc641fd952c1d3c10dea988aa5daf5a7a3ae6241586ce79e5e78d1c"
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
