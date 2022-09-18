class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "bdbe91f12652600e452fdbda29ca3ca522d9f11cf7bbf7b19ae768c90e97cc1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be4a23eec1befc1a5c98d2192c3f1995b7687ecffc57ea54713821ef83eb2911"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3ef3b3d5f8c9f9a48f04064c79e89e94bb2a2d2535ac807ae5c74929ab757c8"
    sha256 cellar: :any_skip_relocation, monterey:       "d33ec1eef701996c8114da24e2717b4815c9f39c51f7a3dd8fa55e7bb70d7ad5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fe1ecf2b60cc91032081b8dbea21b1005bdb7061cb5eaf8b5fa5b1030c1a40e"
    sha256 cellar: :any_skip_relocation, catalina:       "09e1e7e4b06d80527688d9a704f5c99b9e3a5f06863226e6c3dd59d770ab28f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "681f3ddee23b76446456eb542240386ee9d42a79438e15d7f853bf4e72161ce7"
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
