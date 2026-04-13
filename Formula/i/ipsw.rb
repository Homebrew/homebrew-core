class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.671.tar.gz"
  sha256 "dbe190763f743456ba3aab5d58a3cbcb99281a7e9f06b339d5a39e0706c545c0"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4091c2865828b660efbc4855ee8a4b53e4e903416e397025888b20c31a5039a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ee920dcc911f01dd0ae499d56e05ae4f9bb722d7225e8934fb4a0f948bd9c4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00a5a564adb6f270ddcd2528ca1a485fed6047c2476ff449fc85134f2a308096"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c48c81a6950eeb942e374d5242bbc425c9422998b6755255222dea5aae460f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a63ee5adb5c439ea750962b5e113455056dd66e0f9e89fdf5b4a5f3190097e56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6c7401992b1815299a0f975a6f86e04552beb591df4b72329f528dafd5098ec"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
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
