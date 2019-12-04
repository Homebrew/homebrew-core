class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.6.1.tar.gz"
  sha256 "93d40643b2fe352d494cfebdc089e9e924ac0f9e1241ae07644aff549e6788b9"
  head "https://github.com/kubernetes-sigs/kind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "90b44f5c4b4b11526371b974d86c32cf871e7b9d4042fde8e717befa33c3da07" => :catalina
    sha256 "81100ccfcfda9542f639e8b0ab55761085e539fbfb86c9d459cc22bec6981fd0" => :mojave
    sha256 "32d4b9e2e0b243668e10c365c18e85b3f01255d7fb06f5ca317eeb7ee3589d06" => :high_sierra
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
