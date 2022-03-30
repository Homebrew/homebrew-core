class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "c7eabad4e84f5e533670bb78d76c2c0472779bbdb8347227ec699b3387ddc6a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2cf9bcd7fe5557ad41fdcecd5c87442a0bf03ffd56479352573438686e6551c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb7949ba41b1db45f8b17313a219a264c00b797e46f4aaeac5b9a5169ec76fc0"
    sha256 cellar: :any_skip_relocation, monterey:       "b919bc075e95d7ec977bfd214d066256568c84620243b092785fbd00bf8fbfe1"
    sha256 cellar: :any_skip_relocation, big_sur:        "920db2d6002b8c5b381acd8b4d758621c0b3b219aa32f99ffaf7277dd71380b8"
    sha256 cellar: :any_skip_relocation, catalina:       "b9f182cf6e7e6235fd72a393aac35de3f8d2718e47af63ed6a77dac657a410f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9d1ee948a2d7daa99cd82897c99762756cf4b3fc2604d367b1ed3a28c851465"
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
