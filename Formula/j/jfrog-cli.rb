class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.116.0.tar.gz"
  sha256 "06cf9f0f94ceb0fd5f7a371cbd631ad96a530b2015655a83a85df2c4802bf81d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "951a61b9168dcdd1986ea408c9faf2ff4cc46747ffb51732ae13c850e62e3aea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "951a61b9168dcdd1986ea408c9faf2ff4cc46747ffb51732ae13c850e62e3aea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "951a61b9168dcdd1986ea408c9faf2ff4cc46747ffb51732ae13c850e62e3aea"
    sha256 cellar: :any_skip_relocation, sonoma:        "08f4982c615ca7095901218c2c2fa103bcd3716cf624dbb94e90d414bff45890"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5181001a67aa1ec198603d7d3001f4404b8390d12dde25718ed0450ed13a685"
    sha256 cellar: :any,                 x86_64_linux:  "acd72e251d16dd83c8d8b5f31a0e314bef336ca13ba45a28b7e2fd9b641aeec8"
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
