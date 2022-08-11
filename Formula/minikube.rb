class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.26.1",
      revision: "62e108c3dfdec8029a890ad6d8ef96b6461426dc"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae9660e6a96289bfe9c3c8ab6e8e313fcfd46661710b2e77ba75ca315f5648a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78b706d37a0a265df8a83898eaf0cb511d78b2153669d39a2c2f751a72c8edb7"
    sha256 cellar: :any_skip_relocation, monterey:       "2bdf472a85208242313060def43b69c79c4571325076e6854d798442cf35a826"
    sha256 cellar: :any_skip_relocation, big_sur:        "22f479980e0b8c0c0b2857246f8b498f7c0758896ba19d167698b122cc69da6c"
    sha256 cellar: :any_skip_relocation, catalina:       "445bed958a7af5a8a77914f02c00c80eb94fd8cb6761789057e4b5fc4b4ec313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a8b5e593170c5a4eb520dfa86d7b77ed3781f085a5aaa2eead83c31b774534f"
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
