class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.121.0.tar.gz"
  sha256 "c646dae6af75c185ad7fff479705cf7a48f658ce9b06b4a28c72015870b45a5d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cc981a8b7614a39f289d9846a494a7b47c69f19f482cdc028cd0540049cd582"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cc981a8b7614a39f289d9846a494a7b47c69f19f482cdc028cd0540049cd582"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cc981a8b7614a39f289d9846a494a7b47c69f19f482cdc028cd0540049cd582"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d1c0a5c2b47979147f7e8a8a02ee003dacda933b62fb93b8a908c45c9ce090a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b544691a816bdb34bcbf37282d733a2db6170b2ffdabb60e280fcb396e92fe05"
    sha256 cellar: :any,                 x86_64_linux:  "a50f4a562b549d57533d5cebb477e745be395e001c37f4eb9e2854f39a19dc98"
  end

  depends_on "go" => :build

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
