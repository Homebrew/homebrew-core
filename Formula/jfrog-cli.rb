class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "c7eabad4e84f5e533670bb78d76c2c0472779bbdb8347227ec699b3387ddc6a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc8416ce70a074c12ba28e47a8aba73fa185b338fbdd79088f01fbb1f9fa9bf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f53daf975fe4c854c1bad8f818baaefa92449a89031e499778a828451d71eea"
    sha256 cellar: :any_skip_relocation, monterey:       "b4b809e3fd6cf857e1351b43421db9afb77908f6971d64fcfdf18536ab2c56d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7e01323f7554ebe9c0ee605f6a653924218773fc2ec5df8f1997388a6bed9c2"
    sha256 cellar: :any_skip_relocation, catalina:       "9578271eb7ee5d4e42b9642ba16eb4ba5a0f4258db1288c1f16079fb8fbde4a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2201c86431dbd639fdc3d07b9026b1fd5c428ae1f65d621097f1b62fe9ee9741"
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
