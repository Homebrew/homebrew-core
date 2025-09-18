class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.78.9.tar.gz"
  sha256 "15225169645a7e4e5fed016b306daad73e3ed1109828ff95db5d3ba0221dfa81"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcf4ccc9e270b19e2f2ba4fbc9c11bea64c7766dce2d45580c82338bfa5df711"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a6978e20da6a4a1d3caaa7e71c30d61c6d5896ee92eedf4416f7d688597a6fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a6978e20da6a4a1d3caaa7e71c30d61c6d5896ee92eedf4416f7d688597a6fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a6978e20da6a4a1d3caaa7e71c30d61c6d5896ee92eedf4416f7d688597a6fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c39ed7f6f2745041a002a523bc78db9d6f4ac449e476395f59da0694ac0da67f"
    sha256 cellar: :any_skip_relocation, ventura:       "65cf2e5f00144135e38daaf59763da92e8da90a3e6ed087bce6067db02ee5bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc29395c2cf75160883158094bca41de0b3516fab0b1bad3fcc58c2cba185b47"
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
