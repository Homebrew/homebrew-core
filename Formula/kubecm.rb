class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.16.2.tar.gz"
  sha256 "38a812f6ee37493e8297ef4db4061a8dd1c466f72f6e0f70ec94308e8b107856"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1280c573ac13426ef189d3708a37c0db0daf962490bbc94b650d76bc8bd32adb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "327ed093c61beb41450aabdc7220e45821bb76f08df4c7f94b55de8bae722cba"
    sha256 cellar: :any_skip_relocation, monterey:       "ce8c6d750c4d69570a2e649ec0bbfa66916a931d3b43a54d3f92016dabca7728"
    sha256 cellar: :any_skip_relocation, big_sur:        "96246e3be41ce88170e67c398eef549e4a818bc68aa90f0ac45e07ee0a51ab71"
    sha256 cellar: :any_skip_relocation, catalina:       "13f1346904430f3f4f99a6c7bb6d21a6fecdad0a5171ef896a6ceef8c6aebe51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc920c5ad91e3301786a23b6eef1be86204687f224791dfaa2845e04d20a37f2"
  end

  depends_on "go" => :build

  def install
    system "go", "build",
           "-ldflags", "-X github.com/sunny0826/kubecm/cmd.kubecmVersion=#{version}",
           *std_go_args

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kubecm", "completion", "bash")
    (bash_completion/"kubecm").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kubecm", "completion", "zsh")
    (zsh_completion/"_kubecm").write output
  end

  test do
    # Should error out as switch context need kubeconfig
    status_output = shell_output("#{bin}/kubecm switch 2>&1", 1)
    assert_match "Error: open", status_output
  end
end
