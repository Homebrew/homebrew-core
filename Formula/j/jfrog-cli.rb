class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.123.0.tar.gz"
  sha256 "0afcb3a7813cae6d4aebf89430440f55f333fcb288b18f57fcd04cb2e6934fd9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db0e447a361aa234060d81b78f0fe2b0024212da19716bff5b933a40f9ec72b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db0e447a361aa234060d81b78f0fe2b0024212da19716bff5b933a40f9ec72b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db0e447a361aa234060d81b78f0fe2b0024212da19716bff5b933a40f9ec72b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f20ffb0de4708fad05aa5177d18984c505628a30126298547a4d0b7451a9d93"
    sha256 cellar: :any,                 x86_64_linux:  "c8328b775b19f238c8fb7cce1d8a3deeeaafc98710d8f453186c07a6c6217ca8"
  end

  depends_on "go" => :build

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
