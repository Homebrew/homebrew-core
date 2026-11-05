class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.742.tar.gz"
  sha256 "c3eba5cebfc9470c008ff21f0f5b25c8e66d0229a4b90b81401aebf8586249c3"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "00933a8cacea91eda688d12539dadbc2bf584f94bf9ac03048f91cd58960a80d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "663b216fd7fe31d08a623b1e100fcfbe245f7239c8cd4de61346bd9c63e92eec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9bb8781c7bfce165af691bc20e5c162bbc9c15d18eddba420d5bad2e270b7f21"
    sha256 cellar: :any,                 arm64_linux:       "853a21f8cd4f2a0694053040956f60dde97b34c5e4dbaa09d436d809c267c590"
    sha256 cellar: :any,                 x86_64_linux:      "dcba23bab991be9e1e3909cc8e935a1cef00cc89e2b194a1ab3266cba0f65ebe"
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
