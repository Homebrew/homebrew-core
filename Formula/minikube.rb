class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.25.1",
      revision: "3e64b11ed75e56e4898ea85f96b2e4af0301f43d"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d721b4143e7154195201a8b44c3a288fc01c6e8ccf4951af00d74f2166ace091"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f18fe3963d189c56f06cf5492aff733414a548498dd4cfb0f207a2b12c6cdbe8"
    sha256 cellar: :any_skip_relocation, monterey:       "06c14428fd96dea8da38801a00e0b9185f40627f7b5ca345c65be524268620ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "962e2d10d4ff85f6aa440235f36bc11568aee01191e3cb6f4c0f4d548beaf2bf"
    sha256 cellar: :any_skip_relocation, catalina:       "7987a7384f32df89b5d2a378cd466cdfed3f997e553db7f44bfa68e5bf27ef27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a79ac36118d1504ecb9f502094a8e9d174aafbf996c8e6f5d71c70435ea43ae6"
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
