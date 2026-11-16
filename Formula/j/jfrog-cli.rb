class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.133.0.tar.gz"
  sha256 "09e6021bb64b95eb9d8d5b30560b295ddd1e2da52b5d82c39e804d7b1ff3d963"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84ecbe608a095ee3a80071b0ed7216ef337eb916bf668e24131eabd50e38c69c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "84ecbe608a095ee3a80071b0ed7216ef337eb916bf668e24131eabd50e38c69c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "84ecbe608a095ee3a80071b0ed7216ef337eb916bf668e24131eabd50e38c69c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2322126dfde0963ddf47bbb51f1f9c8e341b4a6a8ce5fdc3c7ec87c7afd4fb51"
    sha256 cellar: :any,                 x86_64_linux:      "b30a667c0e161d166a5a569543a9bc65a3fd0d87515b3ec63aceea6ca613a8eb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"jf")
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
