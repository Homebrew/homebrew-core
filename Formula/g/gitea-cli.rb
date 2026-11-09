class GiteaCli < Formula
  desc "Official command-line tool for Gitea"
  homepage "https://gitea.com/gitea/cli"
  url "https://gitea.com/gitea/cli/archive/v1.2.0.tar.gz"
  sha256 "09854deee075d10d1930131c1acb9d3e1f035627bbdad729d4c994410e90b433"
  license "MIT"
  head "https://gitea.com/gitea/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5dbe3ee58b5a101e65a596e16aa93d94003fe1a52afb1dbfa3ffd62cebabd815"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5dbe3ee58b5a101e65a596e16aa93d94003fe1a52afb1dbfa3ffd62cebabd815"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5dbe3ee58b5a101e65a596e16aa93d94003fe1a52afb1dbfa3ffd62cebabd815"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "20e0dc145f3748039a66ac03eb8dfc6097566815bfe5c3b4a845723299fa5255"
    sha256 cellar: :any,                 x86_64_linux:      "14bce4a4547a526b6a52655dd5246dc1895b5a093bac1a48a6420977b7a580b0"
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
