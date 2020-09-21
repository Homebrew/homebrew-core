class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.13.1",
      revision: "1fd1f67f338cbab4b3e5a6e4c71c551f522ca138"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1726a89ed702de810c12d975d8f37af194fd333e06da683427ee5b28d9a36d5a" => :catalina
    sha256 "bf4250427e173cbd054f0dde79ede8aad59e12a5d05eeb46fffd380c97d33893" => :mojave
    sha256 "1c622149766591d0f651e03bb42d6329e6757f663e061a372edf4996afd92434" => :high_sierra
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
