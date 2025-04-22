class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.75.0.tar.gz"
  sha256 "f6713c141ab8f659d717990f92c4b41e7c0adbaec5160e2fbacf4cfab24422cf"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ad1d4c1a4ae2e4a62152622275dd9586cec2bb06a89bf14fa2ba5945ffe8565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ad1d4c1a4ae2e4a62152622275dd9586cec2bb06a89bf14fa2ba5945ffe8565"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ad1d4c1a4ae2e4a62152622275dd9586cec2bb06a89bf14fa2ba5945ffe8565"
    sha256 cellar: :any_skip_relocation, sonoma:        "41e3d4e5d6373329f6ab479de720fff96ddd431d096a532b40a377f15a4e0595"
    sha256 cellar: :any_skip_relocation, ventura:       "41e3d4e5d6373329f6ab479de720fff96ddd431d096a532b40a377f15a4e0595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c8f77b878bdc69ca2e0141c9c378ef4b3c2d39c74774add2018b428ae295972"
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
