class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.29.0",
      revision: "ddac20b4b34a9c8c857fc602203b6ba2679794d3"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a290cff04bd396b39c8cc1ab48410f33aa5c3b474027133ddee2985e779ed8d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee202a22192cc2f1756aab60b18420283cee37d1963fed0da28437db242ee3e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ced9949d34ff27e935ecc4f3812899126cd3a2f1c19ef0dfd38765adc13a5da5"
    sha256 cellar: :any_skip_relocation, ventura:        "2d6fa42f3895d9e5876664b40669e88901b260ac605816d8604e03369f3754e6"
    sha256 cellar: :any_skip_relocation, monterey:       "9d1cbc391cf6a913c8f1c3b8c2450c5abfacaefae86afe4092cddf7dab495bc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd3b76420ed1797727ee383b0a77f19f6de6bccb6653edfeebfee23515f3b64f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "112a0de922c3c3df8ef09fb3ec203af4d643b0b5127b1add3b61784d7a704212"
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

    (testpath/".minikube/config/config.json").write <<~EOS
      {
        "vm-driver": "virtualbox"
      }
    EOS
    output = shell_output("#{bin}/minikube config view")
    assert_match "vm-driver: virtualbox", output
  end
end
