class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.35.0",
      revision: "dd5d320e41b5451cdf3c01891bc4e13d189586ed"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7892fe64bf008ddcbb54b27bca16d162ba2ac2d6aae8c5a80459e4dc063fd6f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5736711e2375732dfb96adf43e10c4f19be2462114311508e3b7c7ef94ea190d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a374a4d807f2fdaf2656cc1ece11ba93d8b339741450aa073aec5838a2da9bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b4fdb423c0a9a216cc41eb9330550b5e23b6e4c069df40b2635fe99a2a4d1a9"
    sha256 cellar: :any_skip_relocation, ventura:       "1f8d986fcb54cc99a5a78d056b96d16ce7760e5dc930710d113a7f5a187e2aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "542f520e0e71d3e4910333b69ac14fe80fa22d566743b0a9f910bb640002e56a"
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
