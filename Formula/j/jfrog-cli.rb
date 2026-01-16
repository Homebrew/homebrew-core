class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.88.0.tar.gz"
  sha256 "8f7ebda6986ad3677143686511bd6d077e4b2d0e61659a2fd571adca85901411"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28aa9822a8c767264ad8d23f429bbb22e8a075b109c35fa1afad3f0dc66a12c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28aa9822a8c767264ad8d23f429bbb22e8a075b109c35fa1afad3f0dc66a12c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28aa9822a8c767264ad8d23f429bbb22e8a075b109c35fa1afad3f0dc66a12c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b75e4943c230151f9412911c43a90e7530498d40d45c31254d049f17f6c7ce12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "885a2ae80524b0832dc68a288ba2ab7392f8b885e1a79d483b52339cb0bd048c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0b235029187d147fb1fcfe3d91584339b46ab754cda5ed485c6e8f5aa01432e"
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
