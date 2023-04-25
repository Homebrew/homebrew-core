class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "5b1eb6d2a693a18b0c5f7ea6445f814c30a7f11bcc6dd58e291c904a61913515"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a87fb426112db77abc470c424c39d3ec445e8a233e4d6912b561fa620095dd60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8faf37b6b9203233cb60d1def7c3728e87b3eda114c68ee27c8af42bfd5bfde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "383fc9bf24983651b410d2bafac7c1e51a93b8ec63ce33908ff63e89b282a0fc"
    sha256 cellar: :any_skip_relocation, ventura:        "59b49042d3921ed99f8909f56eca82bde1cccacaf4ed780a9a5a299f06914562"
    sha256 cellar: :any_skip_relocation, monterey:       "438cede64140189558b9890efc4510b675f746cd723cd909a6a7d5911c3bea4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdb7ebb93575b4eeb88ee4c8487071908219c60f59e418346ce177d240d02aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5060532cca150f521c669d62b6be876b0fdc9b60f57883788dbf9c602562637"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v8/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v8/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town version")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
