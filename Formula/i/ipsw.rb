class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.743.tar.gz"
  sha256 "c86eefd594ae0924c9955978b670fc62fc6583fb72cae3b00281bfd1aaf5868e"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "44ad2171f26109cd7e76c3571eb609dc08d6b3034ffc366a9621adb79b63651f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "83c301a811cf050a31898aa17c84d87d7dd3eb9474f9b667044c028d5d5faa6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8c9627a9656baa29c5dfb4b01c830bdb2a1d56c581ba653dc1cf20ae3d7abbde"
    sha256 cellar: :any,                 arm64_linux:       "1c7b8733e8a7f5e56c107d654764865c7018b9e6a5debc93bebf66ec82281411"
    sha256 cellar: :any,                 x86_64_linux:      "df46b5ef0de8dbe09bd8bfa704e6f321162e204e1fc5817e5ee7b4717636f75f"
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
