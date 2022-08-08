class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.18.0.tar.gz"
  sha256 "b9a5ac1d3fe144caf65783320389d356fc9435c65f3c5b1b2a729d1ab908212d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d404df95e16f70cf6bdd1f11fa4d59a96ffb6d5ac4900750326cd3f7c099a2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74beaf7effc889bef578d9dc32c18ca1ded4914de24ce7484b5607a135cb7540"
    sha256 cellar: :any_skip_relocation, monterey:       "6dc5880a1f59442a37cb91e8ba85add675c6df21cd507ba25269fa98ba4721c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "06fabfc1fa3bde9b2be7a20570955f68a3e2e354ff9ce3d4b16fd86c4f029e9d"
    sha256 cellar: :any_skip_relocation, catalina:       "a6cbbaa24dbe17d29c6382cd7ee8b474ea3ff0ae1d7ca4865efb3d0dd6b1c78e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ff3f6f73e3b91724f82fe1ceb807e40128e40a3c4ccd9aa306f371c888e5701"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/cmd.kubecmVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install bash completion
    output = Utils.safe_popen_read(bin/"kubecm", "completion", "bash")
    (bash_completion/"kubecm").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"kubecm", "completion", "zsh")
    (zsh_completion/"_kubecm").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"kubecm", "completion", "fish")
    (fish_completion/"kubecm.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
