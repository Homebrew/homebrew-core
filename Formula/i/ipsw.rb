class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.748.tar.gz"
  sha256 "a816c3b659ce0038fa44440df7fd7a704c88e67c4e9f88ab15ce3e88fd18ac41"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f553efad9395d885d1df845484e83037dacced384a964e34792711549b8067fc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a8bc30ccd54446735f5a9dec3d4311009abca584cc77859064beb46a3dea5a32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0e9e6bd01c179a2771f74518c781c88b72fa5927fde6152f4112bb62c1f5a8dd"
    sha256 cellar: :any,                 arm64_linux:       "23030b28b0ac39f927e10506c3212628ac15dfcdae9248c3676703f6b8f3229d"
    sha256 cellar: :any,                 x86_64_linux:      "98ab5425074e9f6cb9ea6e07d90c537ff9cdc393d05e22077eaab30f23ae6840"
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
