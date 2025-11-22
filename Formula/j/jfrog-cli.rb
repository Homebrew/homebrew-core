class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.84.0.tar.gz"
  sha256 "64b00022f0ccb05fe3a1a35ca9e9c9595925a0827814aefbf22e439ac382cfd5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a240920eb67d1a20d97bcdad4207db370a7b50c9d0177a87e439f068912f5a45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a240920eb67d1a20d97bcdad4207db370a7b50c9d0177a87e439f068912f5a45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a240920eb67d1a20d97bcdad4207db370a7b50c9d0177a87e439f068912f5a45"
    sha256 cellar: :any_skip_relocation, sonoma:        "91f888c76ef35744567131c100fdf8fdd24e7f57a673de59565df86fcaabdcaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c18d91f7185f6d12444203932151dd2ae331840ce0a36989180d601f8855cdcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5feb2d4542a339007de940164ad4f48b23bc64c176e149a6fa0bba21d04662f7"
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
