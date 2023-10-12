class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.50.1.tar.gz"
  sha256 "2236ac49c38fb2e32a855dd43b4da30034eb9ef5e89512f045941f6201ff4f43"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e03dd91fedd874d0a78287bf507a1de6251d6e6b58add9db508e6dff0ae43c27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4865d53d78fb97e0bfd9987e145f79068f79ebb641d1ec3c58cd9846127890ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f56a7953661512c9d5baedca83f63d623fdb1e04547f29ab89b3b19b90ae3543"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffbe69016b499f97122e333fb032076e978e804c8c75fa4785d675c3a397b762"
    sha256 cellar: :any_skip_relocation, ventura:        "811e5823ac0bb0e926a98423de02a33d586cc8d458a53b958381bbae367a3459"
    sha256 cellar: :any_skip_relocation, monterey:       "ca0ad32774d30198537c824956250876e78e4ac93e3b1ac16b0e4df18f19e546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c23cfa80cdfc68c99d21ef44cc2d19c2e1ab8875cf33b55e90fbc26bd8821daa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
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
