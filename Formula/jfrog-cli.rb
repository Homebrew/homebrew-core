class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "55ab46499145d00a0ae639a5bb9ad588abda78a0f7eaaca2e387d06e151f9daf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e003b6a58dbc29ab2e120d5f4747d2f94e689ad709f3fa8e565264256e322827"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81b41dffb36d53bbe505d05d63070409a76efbc184fada75b8bb4a56038817e9"
    sha256 cellar: :any_skip_relocation, monterey:       "aa454739cea0ed59afc03db56f745c465baf06d25c5248efd587841204ca2c10"
    sha256 cellar: :any_skip_relocation, big_sur:        "98daa6d22ffba1380a99054ceae38a94349822608885119111d1c039d14ac666"
    sha256 cellar: :any_skip_relocation, catalina:       "568363987acd1ba77fa89bc001c1e8c3f1708c330fbb5839ccb2dab19251c6f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81eaf3d2e30828f29df71bc3a468779d84634fd0ebdb796123e349418ded2b4e"
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
