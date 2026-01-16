class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.37.0",
      revision: "65318f4cfff9c12cc87ec9eb8f4cdd57b25047f3"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c7f61cf89a2611e905ce874048d6e3665e11deb82e30bbe77e54b69557a53df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "826069a6eada24bfba97b439ee3b87fdd82484ac2fccc5f7f26a78d25970f473"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5621ba751584daaf95dc7b2bc5983a0395f6e3388bae024294c1ff6cc33e82ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "4319be247a103902e2cc5846988e4afe3cff1025e34707d650d2f417cc8dee0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab3499606f55b82fd8b5c107949d5c32936ec9d8bad49474bcf97b16ed2e359d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c0927c54e6b417bf98d9e52013dd6e634b0189e13e1d741dc8bce690990c2ab"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "make"
    bin.install "out/minikube"

    generate_completions_from_executable(bin/"minikube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/minikube version")
    assert_match "version: v#{version}", output

    (testpath/".minikube/config/config.json").write <<~JSON
      {
        "vm-driver": "virtualbox"
      }
    JSON
    output = shell_output("#{bin}/minikube config view")
    assert_match "vm-driver: virtualbox", output
  end
end
