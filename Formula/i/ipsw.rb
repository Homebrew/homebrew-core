class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.720.tar.gz"
  sha256 "d38e4be048821b1ef4496b268249c05f92f7074aa4ab3988863a8cecb384e770"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c258a7637299a67316756f500c21aed00673cc512431a669dd48451633bc6b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e82ae1ebc53e24e625ef5d409ee435528f9e9602a0d42b27a8ae86df9661b0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10139578cba0bb04c0cf97313b80059ecd4c7fe77be175795593471c60570870"
    sha256 cellar: :any,                 arm64_linux:       "083674cec213d043ab50f6dea9143a9bfff977bd70ee8ad593410c44b5d5e830"
    sha256 cellar: :any,                 x86_64_linux:      "5463f5f69560904d1b2d3221c31a095647cf7a5577dc1dea4f9e7447a7b9fb28"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
