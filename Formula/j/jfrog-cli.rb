class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.134.0.tar.gz"
  sha256 "4d1f8c4cdb50b735c2c5579feb5e0c026b120970d5069d8c0e090d71fd924243"
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
    manifest_sha256 "45618125aaed4205011f86ddd303d023399a87dbe648638929db290e95c54022"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e0f806b7441218c13fd19d611fcaa4fd556230d2be648a9b34936ba71c20816"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7e0f806b7441218c13fd19d611fcaa4fd556230d2be648a9b34936ba71c20816"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e0f806b7441218c13fd19d611fcaa4fd556230d2be648a9b34936ba71c20816"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2799ce85bbdb6d4385563972f44a3cb589ca39e28a86449a3ad85e07d09df530"
    sha256 cellar: :any,                 x86_64_linux:      "eb30ac286559fadddf33b8dfd4d1c988889b13e23c3343fb452d5124942682fc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"jf")
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
