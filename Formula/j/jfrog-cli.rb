class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.74.1.tar.gz"
  sha256 "5682796b949106b153bf81f4fb2f536b6a1753786a8d9ef4f7283de2c1775e0a"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "540b92b41a3f58279e1f3d5bc1562cf548760db21ab7088d6b63d95cf79b914c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "540b92b41a3f58279e1f3d5bc1562cf548760db21ab7088d6b63d95cf79b914c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "540b92b41a3f58279e1f3d5bc1562cf548760db21ab7088d6b63d95cf79b914c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b379338930255b6f75eb006ddaabc1533c1fb4445f106aa86e0f3b1546b96ab"
    sha256 cellar: :any_skip_relocation, ventura:       "7b379338930255b6f75eb006ddaabc1533c1fb4445f106aa86e0f3b1546b96ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6529a21335cdd745fb6dcdddaec2d80251e275b07242972f9a2a371b666eeae9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
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
