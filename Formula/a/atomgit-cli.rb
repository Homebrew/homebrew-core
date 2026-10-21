class AtomgitCli < Formula
  desc "Command-line interface for AtomGit"
  homepage "https://atomgit.com/hust-open-atom-club/atomgit-cli"
  url "https://raw.atomgit.com/hust-open-atom-club/atomgit-cli/archive/refs/heads/v0.7.4.tar.gz"
  sha256 "226a5d26c566360456fd87ad9331570d1b0212dc0b8f5fd2ec85745dcf107611"
  license "MulanPSL-2.0"
  head "https://atomgit.com/hust-open-atom-club/atomgit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a6fc5a6bfd8fae5e29417c66d97da3245a8c9ebc695764b97afc8b962156e91"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6a6fc5a6bfd8fae5e29417c66d97da3245a8c9ebc695764b97afc8b962156e91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a6fc5a6bfd8fae5e29417c66d97da3245a8c9ebc695764b97afc8b962156e91"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cd0a89831dcfa035ea1030a87814682f158c5b4a757bb53e8d12101f5e1a5e8f"
    sha256 cellar: :any,                 x86_64_linux:      "b6dd7e664b7c064279fbb17a8e045409a285493fbff4f3222ef52e039c94e7a6"
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
