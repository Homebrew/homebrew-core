class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.32.0.tar.gz"
  sha256 "54148a471f71f6f81cabf7054bd6b29c5642577296bad2c4784a2021694da04d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "993ded17927c372a11e51e26eb07031b41fb9660d64a93e1f4d8090cfd41b57d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b22e44833f1b5d1b81c6d44774511d9cebf4c6a725f83e4cd0f8bff71503a636"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d51e6e8fd389c193e505f1a9e375bb0b6aaa4885721ec42b691bac4cebcf4931"
    sha256 cellar: :any_skip_relocation, ventura:        "6f004455eb8f28cb4ea61f0f49f9ba8319a677a04805021f59d50d5ea4e3687e"
    sha256 cellar: :any_skip_relocation, monterey:       "92df446a2332f14acd416866bbabcb142dce45246c8cf334d5a6dd55ff5ceb40"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab306ba247d1269f6339f3c166b2f26633c77443cfd553d6b9c34eeb2f33a4d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a857f4b6e15ba7ea6be214bfdd890e92718c15001ab736a01555e5300eaea65c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
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
