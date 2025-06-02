class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.76.1.tar.gz"
  sha256 "8e1a8d7c23716c3b9aa394317b773290a7943715aa72d590652390f7fb5b0dcf"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "v2"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c446eec5d0bd1a52d0b64eeb5e186b335bdb296fa8d0efb14040c577c814a24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c446eec5d0bd1a52d0b64eeb5e186b335bdb296fa8d0efb14040c577c814a24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c446eec5d0bd1a52d0b64eeb5e186b335bdb296fa8d0efb14040c577c814a24"
    sha256 cellar: :any_skip_relocation, sonoma:        "af25b2908968a594994e0fdf125bc2dd4fe12d3b54e95a9ae557a8e7672949fd"
    sha256 cellar: :any_skip_relocation, ventura:       "af25b2908968a594994e0fdf125bc2dd4fe12d3b54e95a9ae557a8e7672949fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "870d0a982bf2d9298393ea33c0c67604acd6ce0fc0038d4d38e3c6d11aaa81b9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
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
