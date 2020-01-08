class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      :tag      => "v1.6.2",
      :revision => "54f28ac5d3a815d1196cd5d57d707439ee4bb392"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "56aefe2d8de9c83559bc3ff540b3c2ac4e3c452d3f0715bb8cf570a741ab7158" => :catalina
    sha256 "4af6de02024bd7d3f0d73e1620dbc3f75f9d74ada020bb20a34048bc58b6dc91" => :mojave
    sha256 "ffc150f88d9a986053427939ee2af10ca757b20b32a3edd1dabb2dd9931a058d" => :high_sierra
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
