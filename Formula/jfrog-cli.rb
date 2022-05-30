class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.18.2.tar.gz"
  sha256 "f03faf282899cdb7773e7f4ce9921f67040078f592b8e4c275ac6d4917d32eb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc4fedddbeeb6710ff014451d673b9aff0a4976f2172f1dfdd146a42d0dd6455"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98cf4a0911ed581c8fd5fe05ed3959a4e38c235f96a3ab0d929f08cda65b3d38"
    sha256 cellar: :any_skip_relocation, monterey:       "d75f2182153fa4e5d0dad2a83b25d6fc4ac5c70109b3b2e352400ba71dd984f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a08f9bdb982c540b27ec3b75fd41eeeb9a18ae794cee42c56efa237ee9dd8523"
    sha256 cellar: :any_skip_relocation, catalina:       "3254ff0065925a44c5e4841c9416bffbfce39d825aed77960acd5610fcaaa9cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d2def62cfe0176a59c0350441ab85c9ae0e6c4a86fc3258ecf4fd90c35c784e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -extldflags '-static'", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"jf", "completion", "bash")
    (bash_completion/"jf").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"jf", "completion", "zsh")
    (zsh_completion/"_jf").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"jf", "completion", "fish")
    (fish_completion/"jf.fish").write output
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
