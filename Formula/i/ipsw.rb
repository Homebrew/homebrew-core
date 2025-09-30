class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.627.tar.gz"
  sha256 "44ba5d3e88b97f581578223fcc72cc27e503f5575626b52d16326e214fbf350c"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c620d214226979553f18589ae7507ff8094f09f1da4fb61ba3c221bb48016a7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5aeba9d416e66d4cc7b33a173dae1bd4d9c2fefef98c782a40f2144dbf7845e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac51ed45859832d449a9f93d44d0a96d3239d430c30bd380e4d6c182294d4972"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dcd65d0996a2ffcd81e979ae6c457ef2e67c2a1c94da02e610160d551ce693c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c01dfb7ae92b1a50c04da4a74a0249c669036aeeb91efade2bbc20d01adddff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a95d644ac30f5b7d2ec814551c14b078b01b764b9c9c6b98e424502a0c3b9ea"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
