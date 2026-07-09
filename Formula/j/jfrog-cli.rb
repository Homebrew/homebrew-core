class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.113.0.tar.gz"
  sha256 "05dcf32f56f4541338fd94722e88ec5017b9163e7cd207112c715bcdf60ad644"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce887c9f61c5357008ff9e411b8ed4b34faf8ab921c84617ef6f1d4feb263729"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce887c9f61c5357008ff9e411b8ed4b34faf8ab921c84617ef6f1d4feb263729"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce887c9f61c5357008ff9e411b8ed4b34faf8ab921c84617ef6f1d4feb263729"
    sha256 cellar: :any_skip_relocation, sonoma:        "d273bc3dbc72e236ad7843044da817c41baaa389b0aff67df2314f3b3a2ce3a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adf0906adbe90318ef60cc99f0a8309866ae2be3713ade16e82f4ec94bba5bce"
    sha256 cellar: :any,                 x86_64_linux:  "670ea2da15534ca9ffc4a6e14b5e2738e57d651d170ea6366c542c439a53d57d"
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
