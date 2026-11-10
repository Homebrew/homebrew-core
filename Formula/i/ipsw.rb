class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.745.tar.gz"
  sha256 "378cb3ac91db86a04f340cffab22c6960c0a228231a9a963bb956f042be3a435"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "44cf940804762b833312ba18cfeb4c7f5e398bba8e86fb932bcd1df82bf086d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c121456460f4681c5824951b5717e06ba1cf58396d6ec2f9f68323eb6d18e513"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7cec23645fe84e6c01aac5debe54d2195c2ba8a11907cc9a791756e37449c377"
    sha256 cellar: :any,                 arm64_linux:       "e2da742a7372772553eae63b9ad500232e775743456e8c2589def2560f398005"
    sha256 cellar: :any,                 x86_64_linux:      "b868a1d245d0f8f9070b80ee4fb99f08917ddcbdf7fff5b960eec78406cd02fc"
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
