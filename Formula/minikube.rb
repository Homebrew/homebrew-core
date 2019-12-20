class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      :tag      => "v1.6.2",
      :revision => "54f28ac5d3a815d1196cd5d57d707439ee4bb392"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e596dcf8e632ede9c7fcdc603220b2d639f7863bf374c4f5efc9e0313590a700" => :catalina
    sha256 "a7dc8c21dc0552fd7c85334a31ff151d47205434e634a7346f85ac00aee0f204" => :mojave
    sha256 "07f995b5d3311834671fc4cb2d6ad54fde5feb236b9343bcedaff5fd945a5ca1" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    output = Utils.popen_read("#{bin}/minikube completion bash")
    (bash_completion/"minikube").write output

    output = Utils.popen_read("#{bin}/minikube completion zsh")
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
