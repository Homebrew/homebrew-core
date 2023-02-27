class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://github.com/yannh/kubeconform/archive/v0.6.1.tar.gz"
  sha256 "f9bfb47cbf5346d96330e2389551539329340ae68e4a47c4e3fb9b627750c9ef"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71d963703797ea4778b0741542c29ca1539db06a018e316ad990a7bbe7cd0f2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71d963703797ea4778b0741542c29ca1539db06a018e316ad990a7bbe7cd0f2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71d963703797ea4778b0741542c29ca1539db06a018e316ad990a7bbe7cd0f2e"
    sha256 cellar: :any_skip_relocation, ventura:        "c11e88e8fa4e3cd81da4fe605f4e19125468b15186fd555c3fbfe39cd6d7b5aa"
    sha256 cellar: :any_skip_relocation, monterey:       "c11e88e8fa4e3cd81da4fe605f4e19125468b15186fd555c3fbfe39cd6d7b5aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "c11e88e8fa4e3cd81da4fe605f4e19125468b15186fd555c3fbfe39cd6d7b5aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "276a85eb4bcfa41f1dc8f1773512d4d822fe980db207e8cafc7d6611f6fed6a8"
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
