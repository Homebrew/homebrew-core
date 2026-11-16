class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.133.0.tar.gz"
  sha256 "09e6021bb64b95eb9d8d5b30560b295ddd1e2da52b5d82c39e804d7b1ff3d963"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17ba34e3c9961e8e1f7d580ab6683242eb62068290654c2ee51f4e3dfe41760b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "17ba34e3c9961e8e1f7d580ab6683242eb62068290654c2ee51f4e3dfe41760b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "17ba34e3c9961e8e1f7d580ab6683242eb62068290654c2ee51f4e3dfe41760b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fc521d5bff54e217c15a794c02a61b5cacc5a4800466c0c78f22043108482c75"
    sha256 cellar: :any,                 x86_64_linux:      "16f742cbde747a1f4682f5804f352ac226b6ef803acee51eade385d58655db8a"
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
