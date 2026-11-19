class GiteaCli < Formula
  desc "Official command-line tool for Gitea"
  homepage "https://gitea.com/gitea/cli"
  url "https://gitea.com/gitea/cli/archive/v2.0.0.tar.gz"
  sha256 "93e204e19c1a0a1b03968cf79f49f7b046e87770150a8c942940b0f15bef3f53"
  license "MIT"
  head "https://gitea.com/gitea/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ba6860fc515dfa8dbd0e52c42b47415627bf35f2555e87c08f24041aa28ee41f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ba6860fc515dfa8dbd0e52c42b47415627bf35f2555e87c08f24041aa28ee41f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba6860fc515dfa8dbd0e52c42b47415627bf35f2555e87c08f24041aa28ee41f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b19e74a39d7c156a164648b9140930499dee814ffc54d2286c6fcd3dd49afed5"
    sha256 cellar: :any,                 x86_64_linux:      "9de89af2cdc1d091ee9536945fb66846fcf1a2e7131a4b835ed6936273062d74"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X gitea.dev/cli/internal/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gt"), "./cmd/gt"
    generate_completions_from_executable(bin/"gt", shell_parameter_format: :cobra)
    (man1/"gt.1").write Utils.safe_popen_read(bin/"gt", "man")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gt --version")
    ENV["GITEA_CLI_CONFIG_DIR"] = testpath
    assert_match (testpath/"config.yml").to_s, shell_output("#{bin}/gt config path")
  end
end
