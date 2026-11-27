class AtomgitCli < Formula
  desc "Command-line interface for AtomGit"
  homepage "https://atomgit.com/hust-open-atom-club/atomgit-cli"
  url "https://raw.atomgit.com/hust-open-atom-club/atomgit-cli/archive/refs/heads/v0.7.5.tar.gz"
  sha256 "b2cda7652c96fce4e573278d355929d2c617a98e86c3bbb68b38d957502b4815"
  license "MulanPSL-2.0"
  head "https://atomgit.com/hust-open-atom-club/atomgit-cli.git", branch: "main"

  bottle do
    manifest_sha256 "921692783b2734a325c8ec4edff993fcef8bc669c925ad03af026fa3ad6362f0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "382a3488be0d58ac1ce924fd94d121c66744eacb3fbce7f04d06869c73a86bf0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "382a3488be0d58ac1ce924fd94d121c66744eacb3fbce7f04d06869c73a86bf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "382a3488be0d58ac1ce924fd94d121c66744eacb3fbce7f04d06869c73a86bf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "40de745573eecd68e1ca592b5e7d93e35cc32be3414e060a9a7b4ae87bd06380"
    sha256 cellar: :any,                 x86_64_linux:      "b11ead330a6572d99260296748dd631d8f55cf6630cb0074ea3658cb2f74a52d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X atomgit.com/hust-open-atom-club/atomgit-cli/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"ag-cli"), "./cmd/ag-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ag-cli version")

    system bin/"ag-cli", "alias", "set", "rv", "repo", "view"
    aliases = shell_output("#{bin}/ag-cli alias list")
    assert_match "rv", aliases
    assert_match "repo view", aliases
  end
end
