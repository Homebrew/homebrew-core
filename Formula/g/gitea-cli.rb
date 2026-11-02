class GiteaCli < Formula
  desc "Official command-line tool for Gitea"
  homepage "https://gitea.com/gitea/cli"
  url "https://gitea.com/gitea/cli/archive/v1.0.0.tar.gz"
  sha256 "587669217030aabf4f1c344187832dbd1c41cf849fc4525a1cdbc11a11390c84"
  license "MIT"
  head "https://gitea.com/gitea/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43a92e16830a1f63fdc95f5d68151b1aafcdac15aa8259187d5b347e1dddd03c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "43a92e16830a1f63fdc95f5d68151b1aafcdac15aa8259187d5b347e1dddd03c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "43a92e16830a1f63fdc95f5d68151b1aafcdac15aa8259187d5b347e1dddd03c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e42dcc8b1d181ea455af2fb37cce26a285392aff15f86704926178c42c6f0a2f"
    sha256 cellar: :any,                 x86_64_linux:      "0770d0be34866e1b69f55e9687e9e01ed52d61827d41377305de3538a76c4dd0"
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
