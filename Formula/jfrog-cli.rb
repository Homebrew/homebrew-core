class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.14.0.tar.gz"
  sha256 "82ac7ddfbc26ca9a0bb578236e5c2f21f3a08a3fc93b5849c98a754acb69b2a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3078f013af5c778c22697997377537e19eb6852dccb6afde85a6f952c5cdf17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9492eef2e61c2a7d1a537baadbdb0ebd7438ec685b5b836acdd92b4157d23ad"
    sha256 cellar: :any_skip_relocation, monterey:       "da2ba67f5550faf22dd3d94248dd48af2e53df609c41df6c611fc45752733fe3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f7c8894de1858b3f4d2cd79a492b5856fda1c4b4b9ad1c22770ea2a8616c57e"
    sha256 cellar: :any_skip_relocation, catalina:       "c891f9128d0204ad51eb4d68e16c21acbab47e265c8bd3d2adca7143d96bcc03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68a79350bd9fd42c1d02c26b124c42c2f964391eae8d7b303f4675917fbb89cc"
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
