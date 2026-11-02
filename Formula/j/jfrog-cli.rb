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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "057f75fa14054e56628c63a55b6bda416058ca146c1c0b21b23887a233c4c69d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "057f75fa14054e56628c63a55b6bda416058ca146c1c0b21b23887a233c4c69d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "057f75fa14054e56628c63a55b6bda416058ca146c1c0b21b23887a233c4c69d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9d1115d6c823edf26de8a122f3f417f844c4d2cd2991d9fce132991976d63298"
    sha256 cellar: :any,                 x86_64_linux:      "2bfbc77da03a712f532352fe3598fd57a2f8e141976cc45bedf62ba72cfbcb8a"
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
