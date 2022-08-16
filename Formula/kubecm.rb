class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.19.1.tar.gz"
  sha256 "4131a891d68352d20fed9701bcff2df148527de4b9e8d1facfcf867be7f4619e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "968b23df98e5c9d0bf505851f05845fb251e3c2943b8a2c451a89d41be0927ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7b774c602ec59f9e3792eb68cfd3becee33dd097074de7f9dfbabc2afd7ec0d"
    sha256 cellar: :any_skip_relocation, monterey:       "5be067e9a6c056e328471105ec16e535dd2e11bb991fbf6b387260f6579d9fc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ce215e6505940f13b5b56384f7a33b718e986e502f88c5ae112352dd80e15a1"
    sha256 cellar: :any_skip_relocation, catalina:       "a93d1824a93b7d03131188fee57c62532710885534a5d601d6d5528f84e3872c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7acf0b880c662cabb1dae33b0ba02ab850a17088a80e18b0ca3b151b14270ae1"
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
