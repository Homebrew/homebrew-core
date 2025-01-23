class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.73.0.tar.gz"
  sha256 "fd087fb37d50aa5da58838be0aac3975076027d3c31f9318f3376ce203104e1f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45bec76cdaba271044fd2c2dfa971df8efb5037086403ee02a4c86b8aca2cc81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45bec76cdaba271044fd2c2dfa971df8efb5037086403ee02a4c86b8aca2cc81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45bec76cdaba271044fd2c2dfa971df8efb5037086403ee02a4c86b8aca2cc81"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e21ab7cb7e0d7e32fe90db749df33686f01f24fa29bdd9dce34cefa83c8dc31"
    sha256 cellar: :any_skip_relocation, ventura:       "3e21ab7cb7e0d7e32fe90db749df33686f01f24fa29bdd9dce34cefa83c8dc31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7365933f1d04c875afaf0eceeef88074371bd074a3afc93972126ccf25c82ad2"
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
