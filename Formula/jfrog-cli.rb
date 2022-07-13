class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.21.1.tar.gz"
  sha256 "9d9d258598aa69bf0cca16ed420b59de9201a3bec72604aa7898b1dd1479f028"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f296608e6287ef5354736fa12fbb2351955416f46343b77a9b8b6c97cac70ba6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efdb2f5b05522b221ec903d2088e85b4733da6390ac5192c0e29265221f78724"
    sha256 cellar: :any_skip_relocation, monterey:       "a7731bcd5066a79612828fb9ddb2f39bccb84ac521a698d5174def6eea53997b"
    sha256 cellar: :any_skip_relocation, big_sur:        "67c5a6e3bbda9effeeb669cc2d02f569b65833e2113576fd86a8eb5e3b1f6c17"
    sha256 cellar: :any_skip_relocation, catalina:       "21fefc5b0f3c2ec2f5eca2ad0f56d0362378c9ad90ab26887abaa53053b1d3ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c9670754381872f4865d15e49de6db3fdf66f7a356bb856df8c8e2e3d6ed5e3"
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
