class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.25.5.tar.gz"
  sha256 "3a74501cdc3dd7d120ace328da5f88138ff255200626f562df0f39ccd172ceb8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bd6c4841545c0f3ec423fb121d31061e7519884c8b76030b8afe8d85e0839c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79b6c9a31c41986571e4eebaac4bd43932bf6e9eb768fb9420a1d2ca4e36aad3"
    sha256 cellar: :any_skip_relocation, monterey:       "d17e0bbf27efc32b696a58bc5c7d4e58016bff9486a16fbfdf85312aefa2805f"
    sha256 cellar: :any_skip_relocation, big_sur:        "66467c07aeba2fdb7f3fb0f7bc152e5de3a5f4d86ab3cd6db25d0df10183f52c"
    sha256 cellar: :any_skip_relocation, catalina:       "510ec6452a4ee25b27b4a75c8b68a26ba3dd2f4a61336cc075cbec6adafe89ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "655374afd4215b3091d4cca0d241d5851d355a50bdc94394e09132af1ffaeab1"
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
