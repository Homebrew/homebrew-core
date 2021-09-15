class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.15.3.tar.gz"
  sha256 "362c61e8703024b1985d948e8c447de15fd2d04ed3bb4945e040017e92df4e9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e8a9ee0a32590ed7f5cd6797075572f54b3ff8aab1794ae3e7269555a7925c3b"
    sha256 cellar: :any_skip_relocation, big_sur:       "d7b26df73ea0ef858c9f04648d2c0fc1dc8cfac664b4998511f9bd57d7a8723a"
    sha256 cellar: :any_skip_relocation, catalina:      "6522eefffc7dacd19c5e22a10a0c5bc826976f15e181e6a8a5a1890d17a1e2a9"
    sha256 cellar: :any_skip_relocation, mojave:        "7a9f0f52e9944d980ad342d25161ed9f5974d2cd727dda7c7237429cf9fa39ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a7db12d204ecb2174bc2826442258543261c2b4da60203702ca295b06789427"
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
