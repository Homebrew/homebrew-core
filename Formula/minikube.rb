class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.16.0",
      revision: "9f1e482427589ff8451c4723b6ba53bb9742fbb1"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f33847f9725a3b15be2b46698403606a1273bad593a875f359a3dbb883ac0b0" => :big_sur
    sha256 "82b215836eaa3232a40153ab9beefe25de0f6c8429deb0d58c4953d7b5ee301f" => :catalina
    sha256 "3251f8023c0d9e34df51df4d1b7f2a28abc0659672184c8ebaa5eb1d7f6d3d75" => :mojave
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "bash")
    (bash_completion/"minikube").write output

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "zsh")
    (zsh_completion/"_minikube").write output
  end

  test do
    output = shell_output("#{bin}/minikube version")
    assert_match "version: v#{version}", output

    (testpath/".minikube/config/config.json").write <<~EOS
      {
        "vm-driver": "virtualbox"
      }
    EOS
    output = shell_output("#{bin}/minikube config view")
    assert_match "vm-driver: virtualbox", output
  end
end
