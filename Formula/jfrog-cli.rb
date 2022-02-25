class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.13.0.tar.gz"
  sha256 "1284879a4ec256b752d226dccea20929f042a8d816d21f630a36b3492c5e9df1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8f472971c6a554589ec9c9e40f300270c7cfd69a01cf3d72724724f651e9594"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c30af10edebf62124e9aac26d3ebe2740bce836aa6a78fb777ab821dfb8def52"
    sha256 cellar: :any_skip_relocation, monterey:       "496cf95930cebd66722fd051df81461f7f3b7fa00217ee1bf8d9d168ac02a682"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fbe126b5069cbc060aac4321172698b3297f70bc045653d509dbc20555dc37f"
    sha256 cellar: :any_skip_relocation, catalina:       "2530636799c6d0cb837a5f68f160008e679d6b96f87bf5c5cd5c763cbf276c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8cf48383c41b3d7fc9af8c8b347675492fb41d47b3e92dcf184eee6b7464153"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -extldflags '-static'", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    system "go", "generate", "./completion/shells/..."
    bash_completion.install "completion/shells/bash/jfrog"
    zsh_completion.install "completion/shells/zsh/jfrog" => "_jf"
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
