class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.6.0.tar.gz"
  sha256 "966b5c9817850f958acf14496349276a8df6d6609adfdc41633a8b7bc73d5e5d"
  head "https://github.com/kubernetes-sigs/kind.git"

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
