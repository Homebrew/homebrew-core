class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.723.tar.gz"
  sha256 "f21140e9eb308083dd609f104a322cf2eb780d281679e1d1b4626a2d9dfbc3c2"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a5cfafad2213dcac0f2bda66e69fe1e235bb619f418930925be9a1f02d0efffd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ebdfdc27340a9e6dabd9012064503f2cb9d4fb206118757eda0c0c8d94c32192"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "533dc591fcf567e5df282194e18127d06c9f93a2d0a334c5b391df24a16a3e4d"
    sha256 cellar: :any,                 arm64_linux:       "79c80d22fb1016365e3cdf80ea5db69581b77ad8d7e5d8633e7e2cc52849ed97"
    sha256 cellar: :any,                 x86_64_linux:      "ccbeeb86799563dba2d4645067fc482c620b8ecbd390f817202e0880038b23b7"
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
