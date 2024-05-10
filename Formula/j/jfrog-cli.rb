class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.56.1.tar.gz"
  sha256 "65823a18cbc5ba3f8f88882ab7bc05ee384919e5adf788ed7ca1b6da252c58f1"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4019b4da9d4886348bb6b06ed6b0a45ca0efe7e3a2c01f967bb453e94c6d3a62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3ea29d3667b86edc98a33f0727c3e3a6e3830daf4b8cc6f1fb9ae82988a1ab1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8363d46b4b0fce8d784f6d04cc99e3d42452034d62eb36027ef9238be596170"
    sha256 cellar: :any_skip_relocation, sonoma:         "a39df7d24fea28d7e2ec1f73728e2de3e109e4a65bdea44d52c9038c5e6dc50e"
    sha256 cellar: :any_skip_relocation, ventura:        "9e3098a0d46d50fc33db77a4f4788d9e5dedf56ac79134ce65d67b1f2c59fc46"
    sha256 cellar: :any_skip_relocation, monterey:       "8c4aa4abeb688d4d1e64cabae52aaa0dc7e558c8ce3192aa6363df8dd7bbab34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "531dc44b03822da7f478524f09fd2b00705b59afbfa89008cc9de9ea239eb819"
  end

  depends_on "go" => :build

  # upstream patch PR to support go1.22 build, https://github.com/jfrog/jfrog-cli/pull/2447
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3872e308ba24cfecfbef3c0ff63a37eaf1c48142/jfrog-cli/jfrog-cli-2.56.1-go-mod.patch"
    sha256 "eee91efc44417aac6fcca53356f01a21ff6c9b5846a5f9d7debaba59a920bbe2"
  end

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
