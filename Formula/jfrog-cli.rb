class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.39.1.tar.gz"
  sha256 "3adfe5034556843f7fff70485c61710bfb2638529730256b12ae7bbf807458a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce751c38a43d0e226558bddc24b8c43c51e703cdba4564e7e12bcc2d8c9927d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce751c38a43d0e226558bddc24b8c43c51e703cdba4564e7e12bcc2d8c9927d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce751c38a43d0e226558bddc24b8c43c51e703cdba4564e7e12bcc2d8c9927d9"
    sha256 cellar: :any_skip_relocation, ventura:        "daeecb53318861450797fd9e21fb7a0431df1ccd966fb89d39adde1b96bae2c6"
    sha256 cellar: :any_skip_relocation, monterey:       "daeecb53318861450797fd9e21fb7a0431df1ccd966fb89d39adde1b96bae2c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "daeecb53318861450797fd9e21fb7a0431df1ccd966fb89d39adde1b96bae2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06f23d8028db2a03ac3588e80f8124ea6bad9b955773b2e9c141b53dca39dac2"
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
