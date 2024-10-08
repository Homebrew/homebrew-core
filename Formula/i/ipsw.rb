class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.549.tar.gz"
  sha256 "036a2239d1f176852841208b312004e031bee4e90ad0d09976f1ba88ea2c5ea9"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1863238e61580cd68de9a8e353b5cb01aa8367f60fa7cc8a701a58496d1fb10e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a8328fecb4286fcf8c982793bf00d3919366e570ba3c749d7ad532fa3708e9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4b21c4e0950592cd5bfa31c1c4fc625b17556893282620d86ff00a3b191b78c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a3e24143d10e2db379c948de7043ae82ace6cb718d1d7e8171b4b5e36d2614c"
    sha256 cellar: :any_skip_relocation, ventura:       "6c3bda8ba5efecd8e1aafd0d66e771fa6a107dc81689e290f897213f917b58b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e352871ce270167e9ab2401dbe648e2d2d5f895bc8eaa53f34140633ac8cfb7d"
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
