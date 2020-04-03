class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      :tag      => "v1.9.1",
      :revision => "d8747aec7ebf8332ddae276d5f8fb42d3152b5a1"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2e717adf9a66bc414e7eda76642ddeb14e753589f829908f0dd4bd7bc5080e8" => :catalina
    sha256 "d099100983365d5bf31cab95892f29be63065544bccb38eba062daed45ae53c2" => :mojave
    sha256 "cc399224d90bfca220ac835af40f785bdfca10fcc5b74f9c628b92e459b0cd92" => :high_sierra
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
