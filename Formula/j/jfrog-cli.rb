class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.79.2.tar.gz"
  sha256 "b10e6c87a7e75534d73caab935c7c84f887aa9720d1a36d96b619d6177bbc242"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdcf2f89c97b6190ef8301d902aed4a4b1ba068767d93b2b512b5124d60dc7ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdcf2f89c97b6190ef8301d902aed4a4b1ba068767d93b2b512b5124d60dc7ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdcf2f89c97b6190ef8301d902aed4a4b1ba068767d93b2b512b5124d60dc7ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d1546220e58b2cf48a50a2c4de8376b99883ee305a2ef3f94f16b0b27c87fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "963d08d86cfb16dd11506ce2e97d8336c3fa187f8043c398de2c6068fc8aedea"
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
