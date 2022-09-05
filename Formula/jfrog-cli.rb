class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.25.3.tar.gz"
  sha256 "213cfa1954ca257fd859fb3b46bebf6493aab968bc7afb8ba5cd23af378a0ffd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "492242cd924f181a646b2efec7410906947ac131b1d0d68eedccd499d9331cf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac4229c15e1b5fb16b8be3251c0e67046cadddbf20a47b54c1b04314626be4e1"
    sha256 cellar: :any_skip_relocation, monterey:       "d10f5fa14319fc17be3e867c03d791a315a5603a7ebc65b85247ce458427ef87"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ccf0af23923220c1b56fe701e2130959aa5324f4969167c93fde60d6e4e5d53"
    sha256 cellar: :any_skip_relocation, catalina:       "4bf892ea10570bed4021e8b6d32cffdad976f1a5dc41f987666f048e9b5c5799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "590d3eeca791b8691de187a25afef05f54ebab6c659b54c6f2a6cec31e1bb69b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -extldflags '-static'", output: bin/"jf")
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
