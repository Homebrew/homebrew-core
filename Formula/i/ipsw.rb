class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.718.tar.gz"
  sha256 "5ff4a7387b4547321e8a3b8853120b5c90cdffe7ed58cccde018bec3500e9608"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "172a1e8081be58586c231ddaa68a07cb487b422eb9901d6eb3d642bcf575d2d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c209d390ee6c67ef75f0ece509a7c9bc4caffe36ab9503cec69f6738d610a66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ede2e0a5651627c8a9cc8ece9dd9a92cb3e3e29667de7e1832d904f637faf71c"
    sha256 cellar: :any,                 arm64_linux:       "4536ab05e4fd0e050353ea98d089ffc8a1c54e433046f9e03dfb6cfac1eff1f4"
    sha256 cellar: :any,                 x86_64_linux:      "93eaddc0c2ccad14fe07b7d6abb2d40f0a64e738c1d44809a92ccfb1974c39b7"
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
