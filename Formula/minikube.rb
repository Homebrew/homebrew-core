class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.21.0",
      revision: "76d74191d82c47883dc7e1319ef7cebd3e00ee11"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c891bcb7b481240bf1661b74baed90eda12ab2bc9ea671dfe5376879e112afe8"
    sha256 cellar: :any_skip_relocation, big_sur:       "3e2c06536603de6f2c1cae599f94a40c2846b6b2aa2543147cea91b862c5c4b5"
    sha256 cellar: :any_skip_relocation, catalina:      "2e42dc4ea7cdf2f4182738578c63870df81e12c6a90ebca87617ed6f2149c8b9"
    sha256 cellar: :any_skip_relocation, mojave:        "eb87ba4bdc14ad363bb365175d7ac055b140f3e6cfefb127e232bcd2e36e99ae"
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

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "fish")
    (fish_completion/"minikube.fish").write output
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
