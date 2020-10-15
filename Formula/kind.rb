class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.9.0.tar.gz"
  sha256 "c154289659a7ef30b301a0787ecfa2e08edaada6059bf5acefe9f3be1e026381"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e5ba99b5f14711e0dcb121a992d74c5ee6c6b0468b27e5200bf796d4987e13c0" => :catalina
    sha256 "d52a780ad6af93a2a7c480a41c5178a461b9966ddc1adb66adde8ff3bce15238" => :mojave
    sha256 "423ea750ae8589d1a199847f746d8e9b5b1f1d81ceff3a9dab2d63f161532588" => :high_sierra
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
