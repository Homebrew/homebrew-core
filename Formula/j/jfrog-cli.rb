class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.99.0.tar.gz"
  sha256 "4639872731f0d4103c87b40b79c63e0bb1b8ca9efdb08e2818998339f3c2659b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdf6eff4359cd5edc2cfafa61e1e71c31f5feffc41b2be5f8c0ddfd04a3214d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdf6eff4359cd5edc2cfafa61e1e71c31f5feffc41b2be5f8c0ddfd04a3214d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdf6eff4359cd5edc2cfafa61e1e71c31f5feffc41b2be5f8c0ddfd04a3214d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4c8e950537c93f5cea6f174a4935d038b8fe511b44515f694dca44dd8817858"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98ae38427abc1ea9fefe75e4bae2d1750c79bc63174c7246572a7f2d1fa754c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff718bf59da97439d9065b707070dc4fc18b7808ad5f9954e2ff7912860cf75b"
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
