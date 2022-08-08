class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.24.1.tar.gz"
  sha256 "a2f02774ff045157810eaa56d48cbe72ffb54823953759ffaada9cf7e2399eca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b4803c46d0bd229072027d8dea26f9ee5543a3beb68dd73778c33c625fe5700"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d79eac17da0716bebc0028edf356a7e4e5e366256676a69477e16570259f6593"
    sha256 cellar: :any_skip_relocation, monterey:       "bbd0564eec90ae3591d00096225525e47a210afaea70ff48db71ea45028a221e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c0b7c775fb28c954630d9b242656209c27f6b2fd33c1da51c1d3096fe6b113d"
    sha256 cellar: :any_skip_relocation, catalina:       "f37e86f85538a096ae77d772f0cce266705ed40dab3435ce292185efbdb9628a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f155bc03708060ef0ec7e640d0aa0bf04e1ffba3091d984e4312bca60ea3690"
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
