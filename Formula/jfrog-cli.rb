class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.40.0.tar.gz"
  sha256 "c1c39c88280c861b1a41aa7bda895c3f00afe51b426fa1b78a99f058221b8b76"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30c818adf583633cce50d8aecdf4eaa182c49da86e42298eef5a0ef455a3d9d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30c818adf583633cce50d8aecdf4eaa182c49da86e42298eef5a0ef455a3d9d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30c818adf583633cce50d8aecdf4eaa182c49da86e42298eef5a0ef455a3d9d7"
    sha256 cellar: :any_skip_relocation, ventura:        "5599ee8e5ae09c470b6ddd1b882404f125f91a3fe3a43307f0f98b0dcd4b40e9"
    sha256 cellar: :any_skip_relocation, monterey:       "5599ee8e5ae09c470b6ddd1b882404f125f91a3fe3a43307f0f98b0dcd4b40e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5599ee8e5ae09c470b6ddd1b882404f125f91a3fe3a43307f0f98b0dcd4b40e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cb6f1cb72efa8dd4c3344cb95994c6a51cd157e4e55cc8b6bc1f8043de26dc6"
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
