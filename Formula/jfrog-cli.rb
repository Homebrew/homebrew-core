class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.24.2.tar.gz"
  sha256 "3d8873a2e1ef639b64228f6a135e2e6e9cae38741a046165c26fc9c4451a5a16"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd0320a908f00119a7810b9a2343a07a959c953a15b78c2e5a304c7879a3ca96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "846f0c0eb4238b16bf651bf3ce565d3b992267c045d8ac936c874208c5021bfc"
    sha256 cellar: :any_skip_relocation, monterey:       "365179f1a9a8ca91cbc918bc19586133ee832250387ba53b7d1c21af7e998b2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a073a0c9e2135280562b2ffc74ff202a8601074b39c6df25c9884cec931819d1"
    sha256 cellar: :any_skip_relocation, catalina:       "7107069883cf6bfa4797101d1b073c4a2db10db3ce7be10d07fd78e402951fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32fef29f3817466e4aaa1589630390b0793b1084ffaf45855fe92185952a04ef"
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
