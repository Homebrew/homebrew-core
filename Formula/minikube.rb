class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      :tag      => "v1.9.0",
      :revision => "48fefd43444d2f8852f527c78f0141b377b1e42a"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b63e55cdf753b1b0e9314a2db9ddcb2d8bbab770780786229d1b63e0083bf8f9" => :catalina
    sha256 "3f1e420d06dfd7e6e73fcb9f6d7ada42885cd5512adc4fc8f9511ba96c46c600" => :mojave
    sha256 "d280ce9053f61380e9e3ea6802b5eeb454d1ac52b5d6798d6b3dd95752c418ef" => :high_sierra
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
