class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.8.1.tar.gz"
  sha256 "2a04a6427d45fa558fc4bfe90fde0b7ea2c7f2d6fcf3b7c581fc281ae49b5447"
  head "https://github.com/kubernetes-sigs/kind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5d016dfc483c522b4dfaafadfdd1cc4a75f67d03acfe241939adbc31055ce8c" => :catalina
    sha256 "8bb7ed79e0577c72cef015922edee274f30c3ce53048cec1b2d46f6a2bb65bee" => :mojave
    sha256 "f48ee5934b269f9e10af04ecb32c5eb06d353edfedc6a57feb3527e5e1c9cf56" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"kind"
    prefix.install_metafiles

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kind completion bash")
    (bash_completion/"kind").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kind completion zsh")
    (zsh_completion/"_kind").write output
  end

  test do
    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}/kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "failed to list clusters", status_output
  end
end
