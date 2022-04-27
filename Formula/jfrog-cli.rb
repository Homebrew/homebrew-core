class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.16.2.tar.gz"
  sha256 "9c4da58c688d5d680602c4ac12505ac7a4bbaaffe1d7dc3a788ea08a087aa29f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62c8a61387b2458aaa4d38563cf60c01497d0c56a0d2344afbd467233372b51c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "950b5ae439d12c55238d84ec74f832017c8401c1a0643b0c078fce4e47c878a2"
    sha256 cellar: :any_skip_relocation, monterey:       "b59490f4a3611a89018d508695c773ce40c72272fa58a17a5a08baa16bf14384"
    sha256 cellar: :any_skip_relocation, big_sur:        "846fcb1a08f3f2bdad8e95a1d63810e15465c28aaddf6dd9591cd6a65488ea3b"
    sha256 cellar: :any_skip_relocation, catalina:       "7fc4fed98fa6f8780ebffdff61598ec61d97e60698b982c572195fcdfefc7933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6663f02c548683afed94aa3cae7d0422d071f7e60d7e3dda7485e43523d27e59"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -extldflags '-static'", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"jf", "completion", "bash")
    (bash_completion/"jf").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"jf", "completion", "zsh")
    (zsh_completion/"_jf").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"jf", "completion", "fish")
    (fish_completion/"jf.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end
