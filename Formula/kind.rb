class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.7.0.tar.gz"
  sha256 "d2d4f98596b68c449be95a31e9680fbf7ff3503a28a0943f1997eba50de208f9"
  head "https://github.com/kubernetes-sigs/kind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a27a7b739d4de87af3eaa80784cf17128bb843d392004ac569b26e4d7d1531cb" => :catalina
    sha256 "0dd0b6740ee5ed21707e85effb654d9d804f3dc3df3d976c54c581e581466ee6" => :mojave
    sha256 "950c7f642a7763d35411cd31814a3f8f382d2b0f0ae5b83f4602953ae6f84fb9" => :high_sierra
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
