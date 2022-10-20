class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.27.1",
      revision: "fe869b5d4da11ba318eb84a3ac00f336411de7ba"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "214bb7cf503615d4ab6dc6f85e080fcd2988bca4e3a40e31efe850bebf18ce9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b09badc559320f75d4a29a3561d9b2dc3cabdf7352886afaf66b61add37fc06"
    sha256 cellar: :any_skip_relocation, monterey:       "c1615fe34a1a9d5fc8f2c4714dab60e5140bfcf0dd9fd8ab681da58b414779fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c4e00230efc17d69fdf8614394d0bdd3fc314ce94a1d99b344ae47698081bbc"
    sha256 cellar: :any_skip_relocation, catalina:       "631c317919169f1a0341fac92cf577bd06b7d67606907dd20bb58080955bb1c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5fb9810c72b6e38c97d6c412914414aaf0179ac5a2e30094a71111e95c7160f"
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
