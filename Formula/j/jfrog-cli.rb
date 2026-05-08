class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.103.0.tar.gz"
  sha256 "909d1761782a3870801662d54e25ffd8cc4028e5bb6b3a095e2bc1ae8024e971"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19cccc4a367c342f1478a1ed8376738905c44ba93dc5eb5baf95ca606c4ba28c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19cccc4a367c342f1478a1ed8376738905c44ba93dc5eb5baf95ca606c4ba28c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19cccc4a367c342f1478a1ed8376738905c44ba93dc5eb5baf95ca606c4ba28c"
    sha256 cellar: :any_skip_relocation, sonoma:        "44a4eaaeb1b5fbb19179859f53e986b210d31463952e891f44ef2056583da434"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bd7b23eb97f0c650f37794a13a52e44c803b6ed0d791854f6af4918687899d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46c228382ae227c0a678327799109ba75c4f46cdc30a38fc4932e0237420ce59"
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
