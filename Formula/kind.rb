class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.10.0.tar.gz"
  sha256 "9ede2b77b451417e36a208cc5183a21f0420f7b6a6230146ba7d76ab34b99bc7"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "21dd92a2adc3dc568e6b6b29a17f85227cf938bd93709ee1817f40f9e1c9a2fb" => :big_sur
    sha256 "4b233d91a8d967dd1c2e0b1cda5abfc9c18d67d7062d74193d6bbb3247726227" => :arm64_big_sur
    sha256 "88fc4241b464cfec95189c325d2d28eecb0b04aeb1d7e56f9d04a7cd82f7ebd5" => :catalina
    sha256 "0e920ee972ce05f98aaddf4a7bc4b591df4fdd19dc95db508dfaa763499ff118" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"kind"
    prefix.install_metafiles

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "bash")
    (bash_completion/"kind").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "zsh")
    (zsh_completion/"_kind").write output

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "fish")
    (fish_completion/"kind.fish").write output
  end

  test do
    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}/kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "failed to list clusters", status_output
  end
end
