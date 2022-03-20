class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.14.0.tar.gz"
  sha256 "82ac7ddfbc26ca9a0bb578236e5c2f21f3a08a3fc93b5849c98a754acb69b2a5"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8f69a91122c3aa6989ab04f45f0c0a3193e0fa083d1cba785e27b40310ae4f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22f5e5f259555d533f3615f71976605eff048725c9694cac2d7771e416ef9fdb"
    sha256 cellar: :any_skip_relocation, monterey:       "badbf3822554e818698c289ad7d80e35523cdd4b54ae8a71631a3bb2c3ba4a4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d88c96c482bb85366499261f74b0c6ab68ffae32da3910b02dc0de42167fbb3a"
    sha256 cellar: :any_skip_relocation, catalina:       "2b3bf0d34baa6f90716e4d33d201168121710edb7c29e4bceb425f6f2a3f884c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23e3523fdd88dbcc5a6d8af2be1160092c3a4ce428567c43a5d8793828ea1873"
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
