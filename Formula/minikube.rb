class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.30.0",
      revision: "ba4594e7b78814fd52a9376decb9c3d59c133712"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebde3026308976509676732bedf7b7054f63d171796796aeb2d94faa128b8c7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4abb42b1f517abb77df0b65882a5ccbca4551881c546da812c94916d7460bf42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27674711bf867cfa67fe664d9489e0b3e0d357ee943b33139c4e1d4cb3b7b78f"
    sha256 cellar: :any_skip_relocation, ventura:        "17cbcd86fa9fe441deef7fb0413383f7f82088a04e374f5c5fe76d2a9dcb067d"
    sha256 cellar: :any_skip_relocation, monterey:       "bed0c19a2540a066d5b083ae214bbd8c48f79efcb5db6511b2d4743794306c36"
    sha256 cellar: :any_skip_relocation, big_sur:        "761364f62fca0bcfbacba2b7094b1abd2780c3faf428d680292c67e2367a3cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c89c995bca926583da5e7053bd57e730353e822034ac124a87c33dfb6bad1c8a"
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
