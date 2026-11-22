class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.750.tar.gz"
  sha256 "46c8a6cb3699a99dff1b305ae175bc59efa1def3fce2173bc511bd2622520ac8"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dda41f0e47ebda5df577e54b4364a0af501769ec4c3e7864c2d8b5b1ebfedd23"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d98024a9e1c2a1cd049dcc04d3c43a2590682266ccecd08a98ac78c9fc2e5438"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "159ce86d681a2a03254a2bbc227bb1f5c1067e15e1fb7f6ec0089b533b9a25b7"
    sha256 cellar: :any,                 arm64_linux:       "f6e855bc532ffb1c8eff8b0e09a0de45f12d8e9e82e11abbec7e15f1b39f34ad"
    sha256 cellar: :any,                 x86_64_linux:      "6ff968d0e0636e15fbf4b27bd3e0ac6c46d862dce6d689688fedede6d6b17c8b"
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
