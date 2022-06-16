class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "d9f6d627840b98075814b30364dbbd52fd5ef6f81f8726381545f61871f433b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faf25b91697ed21ebd50da899c5f727238b95e1f468625ef621579be8b36a145"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d7a53ce10a356d99c3b0b2149321f2be1990b15c2ab97f9bf47600daac34993"
    sha256 cellar: :any_skip_relocation, monterey:       "3aad90991faaab31e37c7c71df35824cf7f15b75132e588d6eae048111db6194"
    sha256 cellar: :any_skip_relocation, big_sur:        "a65527b41d662ff12e1b9427be35de0e4d53911dff049cd96b5be78952141171"
    sha256 cellar: :any_skip_relocation, catalina:       "3573dab1544ebb52578dbd4f5b3e9b5b10cf40c38a616f63c406f7af02cd0ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c45e8bcef14b40b146fdd4d020f5e3b9b4af7ba4487d70d8e9ed9d7f8c5bcb4"
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
