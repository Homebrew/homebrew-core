class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.131.0.tar.gz"
  sha256 "dc3b50494a024cff8ed6f52007dc0b3dc939a640bb34dffb58f704728d1491a5"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0bbc3053faadb62e0b413827ee50ab0abe62f3e9ce317262c9034791cab2ff55"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0bbc3053faadb62e0b413827ee50ab0abe62f3e9ce317262c9034791cab2ff55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0bbc3053faadb62e0b413827ee50ab0abe62f3e9ce317262c9034791cab2ff55"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5236b791a39e56987a048942be2d3e4a272354525430fa2497649d4a63d783dc"
    sha256 cellar: :any,                 x86_64_linux:      "2e4e2af81c7b270542d104f6e7d56fa72ce9c9e4b51e037bc4bef42654826a1b"
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
