class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.130.0.tar.gz"
  sha256 "e6beae32df2b5d0b84bf395969e3e3f8be2628487ad27350225625db3eb744bb"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "57e6d563457ea1b67a1cb16507449a554f44a2c3076ac223a062a026b47142a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "57e6d563457ea1b67a1cb16507449a554f44a2c3076ac223a062a026b47142a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57e6d563457ea1b67a1cb16507449a554f44a2c3076ac223a062a026b47142a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7cb803c53f6e66429a6355f29ba89b0806af7986f69ed931608984bfcce50024"
    sha256 cellar: :any,                 x86_64_linux:      "29421b0f6a27ea12105b894b91957eecb3d8357f98dccf6ddc2d2f34489161c7"
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
