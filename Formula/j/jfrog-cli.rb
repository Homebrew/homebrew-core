class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.79.0.tar.gz"
  sha256 "78c56f951152d7ff2c3584d897e1b380aeb16def71e9f29c75b8150d717d85d7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f369539baf2ee8472678297582ad38a92ca7dbb9a537c07c2ffa8af7d54c3bdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f369539baf2ee8472678297582ad38a92ca7dbb9a537c07c2ffa8af7d54c3bdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f369539baf2ee8472678297582ad38a92ca7dbb9a537c07c2ffa8af7d54c3bdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a21ed005e0cb7e41119d399cb9803afae6ed941bdf3f74d2f63e10f1763a3b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b72506f8d7a8921e50beba569e11ae2acb75ac3e7b3e217e486761815cac0e6f"
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
