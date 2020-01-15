class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.7.0.tar.gz"
  sha256 "d2d4f98596b68c449be95a31e9680fbf7ff3503a28a0943f1997eba50de208f9"
  head "https://github.com/kubernetes-sigs/kind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa2ba3846ebbb34f23bddeb09e646e9c25ce1db629b4e6edf40d7bd9d191f9d2" => :catalina
    sha256 "a8aa767a31255c10b5b93890cfac3eb005b480b6b40220831f1dc235f0d8dea8" => :mojave
    sha256 "12a4e4fdac5204ff6ea47cbcfb16722ba0671aaf1e97a14facd638ec437425ca" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"kind"
    prefix.install_metafiles

    # Install bash completion
    output = Utils.popen_read("#{bin}/kind completion bash")
    (bash_completion/"kind").write output

    # Install zsh completion
    output = Utils.popen_read("#{bin}/kind completion zsh")
    (zsh_completion/"_kind").write output
  end

  test do
    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}/kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "failed to list clusters", status_output
  end
end
