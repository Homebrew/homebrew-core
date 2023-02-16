class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.34.2.tar.gz"
  sha256 "e3537815911a30bff69de7f5e279cabd62ce332d0a21f18d21d9775abb42a01c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cf4669e2d9466ef4ab3a0a60a858c384d7d16e9781d080f236b5d4647043b30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7992f14b7469865067263a2d9e729231187db0ea356258cb3768f8a3190c282a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe774d169250c1efbcb4c118e170a3977c32dc51753fb5a0467525bf06152a10"
    sha256 cellar: :any_skip_relocation, ventura:        "4830b194a5dcbf4f93f3dc02c762bc4810faf5457a0d05eca9fbb1c0a7a34f44"
    sha256 cellar: :any_skip_relocation, monterey:       "a0a19ee6e9dee53b58ff344b3aa33414c8ebbd399f3125bd3da902dfe53b5a2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "18481aa72ac131f87108b7a862b84e56c492d2389037de7057afd68266a083a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45c3238d1e599c032584cddc8202656a135f9bb43edbcf5759244653e9ecf73c"
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
