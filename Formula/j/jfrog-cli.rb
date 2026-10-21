class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.128.0.tar.gz"
  sha256 "c592e0cb9b6a95a8e6f765a8b1b393fddac31770c23086a98713d5116dd8d849"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "177eaffd3617a67ae27dcdd96592617681269842df9ae2155540837e36473456"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "177eaffd3617a67ae27dcdd96592617681269842df9ae2155540837e36473456"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "177eaffd3617a67ae27dcdd96592617681269842df9ae2155540837e36473456"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "acc2d72e50dc5249aea11c7d03ec9e51172d87bf787165a797e4e07e3e7c74fd"
    sha256 cellar: :any,                 x86_64_linux:      "59557445b77ad81fc040c0465640c8fb34b12f80738c63d5eb3c100a06f52cf0"
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
