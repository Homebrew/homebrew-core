class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.26.2.tar.gz"
  sha256 "00a0cf405360ec9c75b17c77ca255cd21a5ad5c4340bc1401a7777c2be164b42"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a2c974cd66d57517546517d44bb577d4e17c24b6492d3033b7c790fa813f802"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "082e26306cce446891aec17e7e4e041928c2e950388b830f57f579b95ba422b0"
    sha256 cellar: :any_skip_relocation, monterey:       "f9ebccf29975ab62da4c88566555df5de0720ae4c4ac6fc9f53f8e05d9fd8b93"
    sha256 cellar: :any_skip_relocation, big_sur:        "f77b76fc755acc92ceaee8faf6d59a132dbe5c602de579a17bf9928f77dc236a"
    sha256 cellar: :any_skip_relocation, catalina:       "188554a29798979109fcf55039340584c30567c1ac0ada710a667df4e2c26a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a15725c424a37a291ac37c93bd1c5aca7fd8f880837ea20c10ca4a328c621bbd"
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
