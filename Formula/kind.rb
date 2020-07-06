class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.8.1.tar.gz"
  sha256 "2a04a6427d45fa558fc4bfe90fde0b7ea2c7f2d6fcf3b7c581fc281ae49b5447"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b3df2d17b1e04549456c846b4e6821b9ba944cc9d960a4cd503281b1d180c6f4" => :catalina
    sha256 "f91154348256db372a2dc67fde509072693993338acb34b89374df138e6c53b8" => :mojave
    sha256 "50ea3dd46ea5e1965bd3cc94e95d30b855ddf64c0a103ee83980ba356a6b2625" => :high_sierra
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
  end

  test do
    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}/kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "failed to list clusters", status_output
  end
end
