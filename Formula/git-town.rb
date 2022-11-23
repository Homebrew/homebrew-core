class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/v7.8.0.tar.gz"
  sha256 "a5c04923307ffe8e6cf6ec3ea720170e1565078af5eebba743556db855da8d03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38aaf3b16dc4cb2dbb00598eeb37853f88403560456949334d7bbf873fd7ce1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23150b97c91316837eeacfe4bd6b94d248c72aa6fff1561a532671d1335f1f72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37e260df95bdcd443c4d2f046ed4f626e057b0d074c27906b88bdca89ce53864"
    sha256 cellar: :any_skip_relocation, ventura:        "a8f318a415c83fc534a6dc61d54a7830bcf0943f857f0ab7d6bcddf482d2fdb1"
    sha256 cellar: :any_skip_relocation, monterey:       "1c8a524538b36b41fb0a6b93ece920aec32a02f0a638a744dcbd1b73f547101b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f25b7b7d58eefe3feb140456534a38f91462f14c9631734a54cebc9fb8b014bb"
    sha256 cellar: :any_skip_relocation, catalina:       "2c94aa810a61a597996c28c7e4e11c2999cb0371d258894766fcb3b887912361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "852977bd794713dba0d1771e182160a83c0d4570ea06b22584acf17e5d0ac783"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v7/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v7/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town version")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
