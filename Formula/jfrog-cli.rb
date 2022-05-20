class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.16.4.tar.gz"
  sha256 "b713aed29a145fdd164f549f748d27dd699ac51c01ad478c3d0c1ef6acffd403"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1ea5019a2a20cecf166628bf2197e8085f355963354ea1f23afe00ecad81d43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5c590345577ffcc4afffb2cd458aa269024d55585a542d4ca0656ccfced2c0c"
    sha256 cellar: :any_skip_relocation, monterey:       "db37d4216905884b6ce7278c6b2398eb7a6e694309a487a1c6dd89c02b26885d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d16ca706ac08c90558690ffe5242c0501fb7ebfd15d8451608b099547a35b43f"
    sha256 cellar: :any_skip_relocation, catalina:       "7f07a18aac63ec63d98f4c3ab00c66914acc6938dc4840bca6e18a7df2cf00c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2bbcc8af7abddc4a065dd09ebbc57c8614c706369c0e4df049b4359614892da"
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
