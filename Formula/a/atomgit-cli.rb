class AtomgitCli < Formula
  desc "Command-line interface for AtomGit"
  homepage "https://atomgit.com/hust-open-atom-club/atomgit-cli"
  url "https://raw.atomgit.com/hust-open-atom-club/atomgit-cli/archive/refs/heads/v0.7.3.tar.gz"
  sha256 "2ff037a7ffa50964ed8927a0d38bde1a84b77a267a015295ea5c5bbf6d42c23d"
  license "MulanPSL-2.0"
  head "https://atomgit.com/hust-open-atom-club/atomgit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d4745eacc2426cba613628ff2f8116a710dd53abe4f64488732953f69b687bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "838d4615d5ade161264963e3afc7b4782a8882d0b951e733cff5cbf68a6f8630"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "838d4615d5ade161264963e3afc7b4782a8882d0b951e733cff5cbf68a6f8630"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "838d4615d5ade161264963e3afc7b4782a8882d0b951e733cff5cbf68a6f8630"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d614f5336262e89c16128ac076af37b3c4372af5dc44310d5c44d50cddea6e55"
    sha256 cellar: :any,                 x86_64_linux:      "88895a76e781dab56dd597fbcfda980a4548b6e6a9bbd09b7fb97f94fe07eecd"
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
    system "go", "build", *std_go_args(ldflags:, output: bin/"ag"), "./cmd/ag"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ag version")

    system bin/"ag", "alias", "set", "rv", "repo", "view"
    aliases = shell_output("#{bin}/ag alias list")
    assert_match "rv", aliases
    assert_match "repo view", aliases
  end
end
