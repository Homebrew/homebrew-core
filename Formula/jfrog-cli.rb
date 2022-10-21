class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.28.1.tar.gz"
  sha256 "d606313ff60a2f7c14b54f2d462fd5f5ed076e404c561b41063402196ebbd17d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "430c6d897d7f65bc8073f59c9ff6d08384c2812c25ff2e590778f3cbfa4ccde1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5f1cb2aad85d5257094495b6246f61a01994bd10ab6359d0375e4b5dd3bc459"
    sha256 cellar: :any_skip_relocation, monterey:       "dd79f465a5e35047972656a5c10b953b476d7e60966f1df8ea777fcd7cbb9ddf"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4ef53955f9731dba882d4db5c2b4dbb87e993b1db67fcfff51ab0baa7ad26ed"
    sha256 cellar: :any_skip_relocation, catalina:       "55d51d2640e7d94c41c86f8a07533a9b5fa302d0cba50d5311b15a843088a599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "043444ca731e257f4358000ae4427fac5cacce3b98a70c475f04d3dafd20964f"
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
