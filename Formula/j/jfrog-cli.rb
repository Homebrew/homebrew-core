class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.48.0.tar.gz"
  sha256 "50f61b6222e3749bfe8b467da720b38145bdd73f2ecc440122d7a18e613e22da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cba1fc6c8e830836b41b7c75478defdd287da4a755679964b2d4304a4128e680"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ec974b9e8a8a28a852a6e15f3a7c6d5ff0e07bdc1f9adadea4988f0d5f1fb6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7b8e2e3b45db7d8a2451ba44ba4d940279a873fba8fcb8e0828ad2cdccfae19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a35ea8e75bd53cbed06a3a3325fd3811b586f9dace11f37a6e105f52218eb5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4aa2b8224c9b7ae459195f44880b9eb1cd00d17290078c4b5606de51d78162f"
    sha256 cellar: :any_skip_relocation, ventura:        "5702b27336b32544c38f500d81f94356276402fa3ab365cd398ac881a7c10490"
    sha256 cellar: :any_skip_relocation, monterey:       "fec5279a6e10b18cfc9dc473f5e4cd19db287e6ae3cd456f2c8f13e250d82e7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a7dcc6033882705215b9c96becf9c56d386a4dcd285684927b41aef04ea0952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28da3449892cb0ea88a032216f9abd0caa1cb1a5915d647e34d88bc0ab800d73"
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
