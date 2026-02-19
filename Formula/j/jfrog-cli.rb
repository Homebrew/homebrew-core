class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.92.0.tar.gz"
  sha256 "bd0e29e606eb4a112a3df0b9538ef080b4b48fb564dae7fb86a2709227816953"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b98e3394df13f0440deb68bb35dcb25cf1e23fea57dfbf3220d0363b206bbee4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b98e3394df13f0440deb68bb35dcb25cf1e23fea57dfbf3220d0363b206bbee4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b98e3394df13f0440deb68bb35dcb25cf1e23fea57dfbf3220d0363b206bbee4"
    sha256 cellar: :any_skip_relocation, sonoma:        "278fc939e3bd802b6da2bcc23dc5b7b576ddb4d1d1c30dd012196a635cdffe6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59e560b5bdc19516e29393f23033cbc66a10c3848ca6697f12461b85f3f8154f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2336fc33c4a9eded45f0fe157f8cc29dde6b7083ea36bd6ae902e36ce41d1479"
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
