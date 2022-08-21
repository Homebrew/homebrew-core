class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "065fe3c7454da3c809beee7e5e7e6a9c727a7c6285c4c1259af7b2e312e9d52d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f49d1dbecf8d846a2a78ea552bd8b91b09f165c1d914de68f1eb1c28aa87e03d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3be3a4d0f2661533bd4627541fbd19a84f1de0709e6b9ab78930017f0818c1d0"
    sha256 cellar: :any_skip_relocation, monterey:       "b19e97dde0d947ada445acfb5a7b25407e4e40e7a2f82f9798636eadadb78be7"
    sha256 cellar: :any_skip_relocation, big_sur:        "980642f183e3cd73dd4a018e21b777341d3a28b39aae7655fe081b001c99d3ae"
    sha256 cellar: :any_skip_relocation, catalina:       "1514ac4866aef9820bc653eaacc5d24f28dfd1975eeadcc70228fb1c5562a188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79b6e462973411580516d2de35d5cf58fcd846a8e4139ce66a40ecacab0220ee"
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
