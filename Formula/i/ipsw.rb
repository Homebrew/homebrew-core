class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.710.tar.gz"
  sha256 "ea0066ae08e07d25f482b609f7e44148b96b5b90c33b3e4ade6023a788ca110c"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41de9e987f23cf55e1924d28852b32f0ff50f2cd47e4baef5e174ed49e475380"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58419f1cfedd788a6a3d04f2f51c5837abf5657e3d8abe910e4b2f0b34855b27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da4e55a61d248620c93d6afbe1b5e30227c4627ab305a8c64bb89c34cbc8f540"
    sha256 cellar: :any_skip_relocation, sonoma:        "847b0d63538d22dcb7e3a5d9cca8c82e20e205904d3fd89f09b0b928e07b079d"
    sha256 cellar: :any,                 arm64_linux:   "222a9247e73cc894ea490215ba24a76a0bfc52044693d0465b6d641ac1a28d5e"
    sha256 cellar: :any,                 x86_64_linux:  "f40b0e68868327baed2f4c8f02e5de9caf4c882aa76577ff15340e1a3f3c1386"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
