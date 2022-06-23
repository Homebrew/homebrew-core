class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.26.0",
      revision: "f4b412861bb746be73053c9f6d2895f12cf78565"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89a6057043442a40fb27fcad58155ec715e58f99bf95d24f93f3277b1af0a839"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7520f937609fa3992b9ba52586becb84e3e5cade7fb756fed465543de989252"
    sha256 cellar: :any_skip_relocation, monterey:       "56fb5f23b5eb1274ca16735577f1fcdbcaccc0dfd74b9dcdf1fe5f8e2f652fc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b66300657406c63a025093a509f6b0aeb318d02508004ae3b4fc7faa6d0546b5"
    sha256 cellar: :any_skip_relocation, catalina:       "21bf510d51d70b66c5d9b9fd94a99523bfc3c1cbf8c951c5ca6a75b10c008613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a87c2b709bc4c74177f6f4e1afad72c8d4c0115b7a86a5cee13d480c14bc7f03"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    output = Utils.safe_popen_read(bin/"minikube", "completion", "bash")
    (bash_completion/"minikube").write output

    output = Utils.safe_popen_read(bin/"minikube", "completion", "zsh")
    (zsh_completion/"_minikube").write output

    output = Utils.safe_popen_read(bin/"minikube", "completion", "fish")
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
