class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.21.3.tar.gz"
  sha256 "3340c3a5e89a601d03de8e7eea2aecd7e4b61f477e6173e45625a4bd0c46ce58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f3f341d869efbe59e80cce854328639e59e4b5a27468700e5f24d6819f4faed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6705c97343957c6076a4a32cb0e656919d752614c8c7470a29038774bb7f370c"
    sha256 cellar: :any_skip_relocation, monterey:       "0424ee339ce0bd1e505c87ff6f62832c00b02a1dd0500b648ebf2d42a2d2cb16"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6a60f6db43b664020d07101e801454dc78a827f301672f133532a03c51c6225"
    sha256 cellar: :any_skip_relocation, catalina:       "45a6fb2d4253e4ee97fa3981f8555f894bf50d39287a8d357bda84eb5d66e311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7695593876cfe2a5a039de0464284094fc9b0e80561eaf011cb02a887d95522d"
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
