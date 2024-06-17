class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.58.2.tar.gz"
  sha256 "a62335e2d4931abdba36761ff945eaabdd3d57a827c8a563d00e4f0b2c4638c5"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36ba4b6e3ae298c62acefc6352a57ef1dfe339312ade47d178f133111fe4898f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f9084319aae43e2ffc29b5f43c8ad66073240004a2021fbff67d6bbd17b2668"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab97c7472c18b07c40d86b2681276b82c2e411727f042ce72461f15fb2fdfd07"
    sha256 cellar: :any_skip_relocation, sonoma:         "26311c198fac0ca2c75a4aabee48cee260ea983e1d32f7e3a63dca05d1059dd8"
    sha256 cellar: :any_skip_relocation, ventura:        "617d91b735c2ecbed68542adcba15b39e8f7896b76dafbecc7c2d5ed638cfcb0"
    sha256 cellar: :any_skip_relocation, monterey:       "15347f4c3d30b4190d9aa625957c165fd59c38d5205180f88129cea5d58d3a15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75275b34431fbf1ca525ce371774c3cfd1ef187d5813284decbdd5b3dcc883fd"
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
