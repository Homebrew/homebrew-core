class GiteaCli < Formula
  desc "Official command-line tool for Gitea"
  homepage "https://gitea.com/gitea/cli"
  url "https://gitea.com/gitea/cli/archive/v1.1.0.tar.gz"
  sha256 "b48b90f1427fac8779f87d1f014d62b2b7513725da11677910bb04577d3cd710"
  license "MIT"
  head "https://gitea.com/gitea/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d4228797002d7b2f0118ed9271cf8eb972b91d2dee72b75b60378b8f5b710cf0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d4228797002d7b2f0118ed9271cf8eb972b91d2dee72b75b60378b8f5b710cf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d4228797002d7b2f0118ed9271cf8eb972b91d2dee72b75b60378b8f5b710cf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7f577dd5393bef17917b7e627591e7f1dc605cb9a1ee4182a8984375263c7023"
    sha256 cellar: :any,                 x86_64_linux:      "12d1d6b4f935afb9be5f54a8466b0e59a778b32e8fc9ef8d91e9a9216c451976"
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
