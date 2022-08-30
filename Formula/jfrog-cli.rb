class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.25.2.tar.gz"
  sha256 "7849419dcfed8ce92eee183e7d29432d58515db0eec36059d93eb21a38ebaf3f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e2b24f58322cfa0e0acbf8fe0f802454cf50ab699f5e5bd89a9287946dee2a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d84b1d0db8c7f640c726fb3738890c84ca8617f00a5b7359a274c81e58868b2"
    sha256 cellar: :any_skip_relocation, monterey:       "de2a1230d9854057413c4317f9a64fcf2d0803a10e0be559bfbee4835453c03e"
    sha256 cellar: :any_skip_relocation, big_sur:        "73b65837b31a4e1d4416a2ccf56cbe01cfb67563a04f3c70f4dccff948af2db1"
    sha256 cellar: :any_skip_relocation, catalina:       "e421b1306d9ab4454bb335d82936b64ad6bb550dd44f4d25e5698895aa532e08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcfe49600d44799d16026d5502bf9547e2fa7943c184c99bfa458105b5cc0a2f"
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
