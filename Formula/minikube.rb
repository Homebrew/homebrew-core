class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.25.2",
      revision: "362d5fdc0a3dbee389b3d3f1034e8023e72bd3a7"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c20abe357ff2726082b8eacbc3a4e286a7e030bd1460f5a7ded5e559ce2e330"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9758947d5f4424b19865dd3260ffd041175d8318eaace49fef67f15b745bd0c9"
    sha256 cellar: :any_skip_relocation, monterey:       "55bb120a3c56de1237e827772e22b63332b846694affdaca249306643a9da7f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a617029b4a94477847087fa368e8725a74dd3a6a188e607307f3ab8c533db339"
    sha256 cellar: :any_skip_relocation, catalina:       "5d119f190435d45fc83b264e6377e92318ccad9303996ee8e82baad083a04dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d33f239e285820de9e51773078b1a9cfc100214382af36dfbe7437e005c80df"
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
