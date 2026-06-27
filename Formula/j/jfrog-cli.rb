class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/2.111.0.tar.gz"
  sha256 "86068668723ca771e5a93c8ca2d069c4d7b4d3b2559340765674a1a0afa2f07e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "301f7541d29cc23bb47ce04bf858c468d82bad5b438dae77d84c62d42e36501e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "301f7541d29cc23bb47ce04bf858c468d82bad5b438dae77d84c62d42e36501e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "301f7541d29cc23bb47ce04bf858c468d82bad5b438dae77d84c62d42e36501e"
    sha256 cellar: :any_skip_relocation, sonoma:        "287d2bb857384df5249ae5214f5996ff0c77ccbe829b0c6844524b62cde7946e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08cecf3eddc6509d02ccf4b221e7d4022c46360bd54a63b29a6c65eac8fdec4f"
    sha256 cellar: :any,                 x86_64_linux:  "e69f3bb9fae718b0101fd4f51b66bf44108fa4eeab5ff1df3b39587b7d569fed"
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
