class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.36.0",
      revision: "f8f52f5de11fc6ad8244afac475e1d0f96841df1"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9a0f9e6e9218387985c3dd006b85fbfd8a83f76578902da2bc15a3753bd2839"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bb68304211a22200138c1628a1d9219ac7eb232d5b26250ba7acf51f3ad56c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8886f6dcb989da5200876bf37812feb6753c9c5993f1ceee5b22e9aa28978dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4f71b307da52d9330119de92aaa6c301e10dc90e29e1f557ea839abca4a18f2"
    sha256 cellar: :any_skip_relocation, ventura:       "d56acc2227c9190e0b9c10f8ed690d01d357185b39d9d887e0a103f561283408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9483325f7d5ca55313c2f4d6bb0c0186679db28259a1fc5dfbf7e608f16a753"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    generate_completions_from_executable(bin/"minikube", "completion")
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
