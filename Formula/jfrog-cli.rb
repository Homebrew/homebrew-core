class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.34.5.tar.gz"
  sha256 "78b30429b1bef7e8d0836921c70bab53bc2dc4de3123a361d2f6ae1041f15ab6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1f2ebdd6de130e4d666efc4bda043985aa2a373db1fd8b834c6c034eb438995"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "238254ed963ea09f4d3cb7e0e61480d1eee06bec2b83996a86aa7b57223042dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3aeb3eda4894f93958c7cd56054651d98e2967fe21d68c5e4ef8001c6c18e28"
    sha256 cellar: :any_skip_relocation, ventura:        "0ee5b0de6f4a61f0a813def80e3ebcd54045e14347be81c5fe1c0ddab07241b2"
    sha256 cellar: :any_skip_relocation, monterey:       "07bccbe1a8d1a75671e04e205f959348b5703cd7588827f82db15f686b5e5aec"
    sha256 cellar: :any_skip_relocation, big_sur:        "03db864bd11229f3bb0eb1f485633788fac3a744eb36c26931df17f4b587e919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b86430974b7e02ee09a481d86ba0f3b0b2fb2356225f0aedab1a521a0514b52"
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
