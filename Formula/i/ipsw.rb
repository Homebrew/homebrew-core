class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.595.tar.gz"
  sha256 "d9215302c4aa4f6dcaaa956351e4f2a7357c05b4757b8e18bca1ee6a34495a92"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63562a57f6775c3ae618fb164b1fbb3db7fb3e29f30f33636d0c53a267d62825"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7997b8b3222b2ac4be99f168145e90ac9b26930bc8b35adef210a25f1c165f9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da16ad2f53e08dd8c9ca9dee9040fb7ff1fd4f142cfea160572d3dbba205f95c"
    sha256 cellar: :any_skip_relocation, sonoma:        "aec3a4673877fdb352acaea60080486b90ccb4682049f2a9a3b0032bf2081380"
    sha256 cellar: :any_skip_relocation, ventura:       "beef6e5ca2b7ec62c7cbab5543689f405f6046157ae3656a3987fbcae47bf6d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77c59c3faddb53c21d241d39f98f5b7bba3c8c5a88f87261f6c73de0a6db1915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4efbd447c831a34b5a689673c97954b12955f4a9609f0eb1331def644ab1b04"
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
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
