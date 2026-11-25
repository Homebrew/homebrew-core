class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.752.tar.gz"
  sha256 "06407cceb8e591774ffe285a7bfb430692f5914b3ba4bf21a20b4c2c0a9ad4fc"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "8f6c13321c72de79cab9be5406861a19931e3e98bacc5deed4a163fa91c125c4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b601e31bb7d79e5da6b205cbbc17b09be7fbaa3011f67b1ce816b2eb81a9c76"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "147388a95ed3d4fd9bf22c43cd69377ed9b73f50f15547200895241bfa5111a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "667d918f973db84c5b07e6448918f1e7854308bc5ea5f6c16911aecdea0afa08"
    sha256 cellar: :any,                 arm64_linux:       "2596a3839624f90b3dd5ab6a308adb3af63c5d72d19b4792e1defc6fc46d682d"
    sha256 cellar: :any,                 x86_64_linux:      "1f6a3e5143d12e4f522769446c726001118bb9078f0aec87a790a1d6b358eddd"
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
