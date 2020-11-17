class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.15.1",
      revision: "23f40a012abb52eff365ff99a709501a61ac5876"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "892ecfd803b7cb1707dd2337203f2f69bdf1a1c652291fbc19c70d983847feec" => :big_sur
    sha256 "0d476aab2ae7258f2ec75fbe59fcb29ea819817cbdb48cc5aae3c3e5b71562cd" => :catalina
    sha256 "ef9823a312d38aae6115f2aff2073b7410ce6996cc3c752c4fd6deac51a4333b" => :mojave
    sha256 "497848b23e38b192e03f0b8f3e8294482b71fba356dbf6abd43bbdd9e5b50972" => :high_sierra
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
