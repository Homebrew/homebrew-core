class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.23.0",
      revision: "5931455374810b1bbeb222a9713ae2c756daee10"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "95e668d41909b00b7fa6132725d29bc84a2731d8a427b8c82354fd134797d0a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "3fcf314abbf259026cdb09ce207df936fbdff4f9d04296cac4dbb24e37dcc695"
    sha256 cellar: :any_skip_relocation, catalina:      "58d3876ab478925a59ea09757bb4fd2988aa3b1272d3e5e45a1fb0e8a6b8617c"
    sha256 cellar: :any_skip_relocation, mojave:        "aabf29b10f42f2ba9bbd0319319ce0e27d998632a4c48b7f8722c6c521e86117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0da6f12b3622aa93ee5f12e7f490bb6e607049eedb1f0d90d737976a99ecaf0"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "bash")
    (bash_completion/"minikube").write output

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "zsh")
    (zsh_completion/"_minikube").write output

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "fish")
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
