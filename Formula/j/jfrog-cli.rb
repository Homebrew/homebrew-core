class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.46.2.tar.gz"
  sha256 "800c038f59d3f20421421dba6298bf96ad90d90495f070fe566cd7e9fce41f96"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "862661e727b8993f7982e8d8ced18b88977507d2f52ef71a6f6d15bf1399131c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d7437bd18c561b58179e85632fa4e8489f43d950c42b9ca5348ad29b10fcacf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0da9a5b1596eb3df91b129bb5efe55fca9c7f2c34c4d6e07503c4eddff6cba1"
    sha256 cellar: :any_skip_relocation, ventura:        "2afead67b31406d4332424c7de964ca2e4d3407300e862006d02690eb852adf0"
    sha256 cellar: :any_skip_relocation, monterey:       "d4314acc82d63d7cf678227f267f5a80e402903eaaf3124238debfb9ea1ce10f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bc843325f8f359cb963e1016092d3f85a168ac037032cc20ce458a3e3c3bc51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93bf55258983085ffd9b6735675f6c4b79ad3a08e989e77ea02f1158a41cb9a5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
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
