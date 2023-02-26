class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.34.4.tar.gz"
  sha256 "bb0532bb51df688b17fe81ba03f8770bb43f6e1803e448efb032ec099eb30094"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "278ec67cbeb35ef2733265d20468e118a1cca1d4e87a6ef1efbcc919bc1fa30a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f93c3d68068a1c54dbea950e928884c3fc4fbf0a953a0eae903f714f23bc77a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c85e4cad0b3d7433862f6df410e29e2fa18b2266661f827b8b0014a24988ca5f"
    sha256 cellar: :any_skip_relocation, ventura:        "7d384603363f5e301a611e1c2c6416e96ad5ee905ad09d20b6a54f6709e2987c"
    sha256 cellar: :any_skip_relocation, monterey:       "be6a8a07320c93cff37aa341d905b218c8900e7dbf39b21af5588024fad55251"
    sha256 cellar: :any_skip_relocation, big_sur:        "40bc9bc41687affb7e127c1bb8c2e273e56d404c5b55398220f9cb4c840e840f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e031520f05487b46c83d51e04e1ed9e3010071b892bd174582897be74cfab080"
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
