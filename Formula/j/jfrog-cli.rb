class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.77.0.tar.gz"
  sha256 "a73b10409e95b7a3e769f3ebeed3e9b8c7db5a822d995cb7ea96700c9f579bdd"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26a13f97b1cac8181a689e8088b4b49b3b59303d9b9bf1be42a2e45d685ebc9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26a13f97b1cac8181a689e8088b4b49b3b59303d9b9bf1be42a2e45d685ebc9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26a13f97b1cac8181a689e8088b4b49b3b59303d9b9bf1be42a2e45d685ebc9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "37f382e2c4ac930ec9d955ce6b9fee5339ebf2c05bb09479a449252f304b7dd2"
    sha256 cellar: :any_skip_relocation, ventura:       "37f382e2c4ac930ec9d955ce6b9fee5339ebf2c05bb09479a449252f304b7dd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b52159aa910467f8eea2de1512de3e6497bb594d1bf69ddcb18fc1e202bc73a4"
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
