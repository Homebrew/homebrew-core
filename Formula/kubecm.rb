class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.17.0.tar.gz"
  sha256 "b1e1a34174f5178107ab62af95f10d016d5ae271ac13b6066880393f6936349e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a4fe26640ba54e2cf12dd39edb6bbaa5e4d66ca8ef98fdc3ac53465ccccd3c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b274c3c681de704c4f2bd49b4c239c9566e323864b208862f7e9492150cbe92"
    sha256 cellar: :any_skip_relocation, monterey:       "d4cab40ed31f5087b97bc28d0ce8c4b1e1b756df44047226a46d4c123810b430"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0e0425b1c31821f311857c4b41d94fd25ea3f5eea346b43a84ca6aa10c89ac4"
    sha256 cellar: :any_skip_relocation, catalina:       "05651d6e54444a178cae92d1d488b247cd61111598049bdc6ced89deecc4ff8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c2b099ae9073bc89230b241b68489b5f3d10e7d86644039baa0dacb15d01f19"
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
