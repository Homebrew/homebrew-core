class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.9.0.tar.gz"
  sha256 "c154289659a7ef30b301a0787ecfa2e08edaada6059bf5acefe9f3be1e026381"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae4b118e9c55007ee38e99a1a37f9b3693475a0c25e90670e63773b9304f44d2" => :catalina
    sha256 "e32358095a62316019b620ffaa49bd94c1d78a6257ea6afa3e665ffb3fb6dc2c" => :mojave
    sha256 "76c237b09ab616c4a1b30d5a3cb4a6a170a35b79863d704b86909f4044041c04" => :high_sierra
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
