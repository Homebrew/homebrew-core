class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.102.0.tar.gz"
  sha256 "8370b9ab1f98f5a542d0a2f65e33ea0c4eadaee9280b9cc1c8355bb3a990dae0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "869142832145c222fecac606cfb19c4afe65d080373b70f183796033f4f83270"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "869142832145c222fecac606cfb19c4afe65d080373b70f183796033f4f83270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "869142832145c222fecac606cfb19c4afe65d080373b70f183796033f4f83270"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb4c81d45a8c99ced8e64b51b6d8b58b96937f6b81b6dfda39800713f2bd9fe7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88607bbc37b38c86f578425dd5527ae1b3ec8aa9b8b669f52e83a326e04e538a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48db5f5598938b141037ebb40a91975ef5c1471244ad13a6345afeabb34a70dd"
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
