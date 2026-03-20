class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.96.0.tar.gz"
  sha256 "04fee5bfab110e570da71a4e5d5c3070c0d3a73d68bc2d0de2ff87f210d6e756"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a138368e69c99cb840dfcbee0dd8d82c95dc6c7d71da5159b445cfd9425853f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a138368e69c99cb840dfcbee0dd8d82c95dc6c7d71da5159b445cfd9425853f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a138368e69c99cb840dfcbee0dd8d82c95dc6c7d71da5159b445cfd9425853f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "634c1fc313b1411093cc71c4609b0ccf7b8d467d3ab9f61ef4a375fec05941f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c9e29a08fc569dc777dfbf0c506efeddaf8fd12d91edfb228fa7a2b1d1da04c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95cfe87f93762deb72dbf681eb14b447fa7238f61b72982ee78e038387452ede"
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
