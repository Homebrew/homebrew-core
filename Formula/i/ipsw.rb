class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.550.tar.gz"
  sha256 "28145424ca0a8487220a5941b6a6e93b2e393c734695d314c3afb27981f945e0"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "886200b076bab0527d492400d903dee24919f33d5196b1dd1dfb6b8160deae4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "194a55c21d3250eef451d7659b5d9bf3f2ff3d9445ee9713447abd88de6ad295"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58ab5b4c2dc6af386a406238862c509576f9a10cfe0b76cd981a5f0c98f33db9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2231a9709af7ddc6c9bc711db8d9146aa6f03fa07e19c1101fb72b410bf306e"
    sha256 cellar: :any_skip_relocation, ventura:       "4448a799275f47e641aedc00d3d23de6d8b979a3e0393066be65750ef2314032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bccede62c9d3cd63ba600cc880e2bdeb435eff6699ab437470d8154839c9e46b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
