class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://github.com/yannh/kubeconform/archive/v0.4.10.tar.gz"
  sha256 "89ec81159540d73cc9de43a055da784dd226b2819debf247b7aaaf6bfbff9f7c"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "84f279b5cd4c7b2dcb0f0fc107c16f7db0f6965885fde03a8253d56b70eedde1"
    sha256 cellar: :any_skip_relocation, big_sur:       "0bd164e1c64ecedb2c3d59419d15f93b8438e08104718cd622169f5bd2e8e012"
    sha256 cellar: :any_skip_relocation, catalina:      "648b9decd75ff4cbe3997c7978b9bcb1a084e9ffb11917711f1bc7ee12deda93"
    sha256 cellar: :any_skip_relocation, mojave:        "f59969a27943b57089d8a1a936cc112eccfcc6eeb013c7625a4606c62bb33de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bf0992081b28591a947a0ba845b064284bf625a52ef9624c3a2b0c4bc05ce35"
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
