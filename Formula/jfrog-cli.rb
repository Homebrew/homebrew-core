class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.34.1.tar.gz"
  sha256 "4855af2ad21748ae2a28e02edf069c46d1eb8222e55c75e0e21c2192b05119da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00d55afb14ac264617948252c2b4504e10337dbe0cf93427a6cb35dd6a4397b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52a6692e55abb3a2fe370c42150faf287f30824776c1a98d63630cdf3cc94363"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c365d71ac092d13a25854855a2fc10ed88c54efc30addcce8201bcdfaa6279af"
    sha256 cellar: :any_skip_relocation, ventura:        "d7500faff4855afddcaf1d292548b6c80e1b51077d1f462ea163b12795ada6c3"
    sha256 cellar: :any_skip_relocation, monterey:       "a2b6b5f1143c2435d404f4d23fe3e5627f41b4d7f7c72d623714a6fc26d5e0b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "55caf1bc5baaf9fed534619ca134dbd985798662c4670b518f8013875fa3b960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5069ad085bb0454b381ba3ac41f6c3c3498db7af1a69a315de85b4811fac7c11"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
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
