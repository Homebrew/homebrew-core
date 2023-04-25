class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.36.1.tar.gz"
  sha256 "a9c955de6608f1e127fe43ad64cdf97170a779922a93fbb60d2e420809faf04e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4172bb1972ac6d0648d3c760a6dd1c3dc7366551393dbc907335bed8d7a11b93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4172bb1972ac6d0648d3c760a6dd1c3dc7366551393dbc907335bed8d7a11b93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4172bb1972ac6d0648d3c760a6dd1c3dc7366551393dbc907335bed8d7a11b93"
    sha256 cellar: :any_skip_relocation, ventura:        "aa208b5d74d4d85fa2221f1d3ed23709b95461cb06f51703ea5fb83c7d8ac82a"
    sha256 cellar: :any_skip_relocation, monterey:       "aa208b5d74d4d85fa2221f1d3ed23709b95461cb06f51703ea5fb83c7d8ac82a"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa208b5d74d4d85fa2221f1d3ed23709b95461cb06f51703ea5fb83c7d8ac82a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8e07f89dc244d7b9a494afaef3957e94e8b92d086b193e8ec1353aeac45aa74"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
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
