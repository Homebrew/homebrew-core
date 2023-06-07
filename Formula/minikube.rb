class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.30.1",
      revision: "08896fd1dc362c097c925146c4a0d0dac715ace0"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d74c3581ec6420d173393cdffe19dd104cf65c49f6cf7a8b6161aa165d4f2085"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab6787c86b4f85eeb86080b7be42e41ad8bed5cb7199fea4d5eb42993c151657"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4984514d21ffcecb55e8d9b35fad31a9ed596e56de30688a594ee635f8b79ab2"
    sha256 cellar: :any_skip_relocation, ventura:        "0a74440415ff5881db92af6c85aa1c654e4332827230a235bc71778f516d2c21"
    sha256 cellar: :any_skip_relocation, monterey:       "89f3c7a7f17b6137dadbb4b45da796010ead71960d171c376a8faf54204463c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7efe4f6a6892d211b81145b07a7accbbf921ed243b7493deb9879235728ce94f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "775e2343a6f56eb7f6dddff34ff4ec3ae3f27195734e903271b761bc34508c6e"
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
