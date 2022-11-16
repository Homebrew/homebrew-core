class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.28.0",
      revision: "986b1ebd987211ed16f8cc10aed7d2c42fc8392f"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "638f1738d9b59cfe6d194aa27888ec4fa8b30aa82f367c8b170cf33ca176fd2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91c8e0853c19fcf0ddff42dde117f9c348bc1b9cd6090a5fadb0b80cac1896d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e87d89e237fea75147a58badd196e36b4880370b3ab134b227238ec22559935"
    sha256 cellar: :any_skip_relocation, ventura:        "7e892277033822ca4db0e12edbf49495f4c2abf36bc2db058ce10ebcb7e83428"
    sha256 cellar: :any_skip_relocation, monterey:       "b5a5d42e904668bb4552a6acfa77277ecc1c5a6e435654fb5f0344c6bca9ff0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "17f4213ce63ee73efb7e5b26e4755a152248f807d5d58638001d21610c0b34fa"
    sha256 cellar: :any_skip_relocation, catalina:       "fba074d6203fc1a6204d15f97121de73e04236e68b9c68bd5466a33846b1151a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "219b261d714695afe2a416445b61add331061a3b08ea9a4d916c85373fb166f4"
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
