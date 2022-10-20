class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.28.0.tar.gz"
  sha256 "b9009db8cfcdb9ccf527a0cc3b49893121ed0cfdae7fc5f88463d80055bb455d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8cf87adfd9dd6a463d61bf8184115d778af3b13011843c9c6af3313d55ef99b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dfd22257c4903eb1631d104b97a21faa09bb44d2f7934b24a0d8348debfd7cd"
    sha256 cellar: :any_skip_relocation, monterey:       "c52f1b8df5cf4382a86a7917e38a147042ede5f9e85034ed955b86e020474fa0"
    sha256 cellar: :any_skip_relocation, big_sur:        "edea997e92fd6f890cf088862bec6d00a2e6f0bf53073e75937dca6750f3bc6a"
    sha256 cellar: :any_skip_relocation, catalina:       "e50b237cc361b8c05beb8e8b481446ecf808fcf3af63f66babbd6b2de8e98876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03c263ae377a9df35e48fb48ee069b12cd1b502079be3452d4555940f98a0703"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -extldflags '-static'", output: bin/"jf")
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
