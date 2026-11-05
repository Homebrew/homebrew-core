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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9de97b128f1f517bc85de06c509645f9c06f9b367972a46040402ca3de65c007"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c7cab68ab7b99d6c8d17d2b0f0e86ff08fe5c65e998db32938fb9f5eccd3393c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8926f226bbca7751daa1f5deb0b42b1773e294b9b1f4d4ffb094070b84889c0d"
    sha256 cellar: :any,                 arm64_linux:       "7e32a12638f9549172ab1c2539ccafab35879ee3fad752f2e3e02ae21288ceb6"
    sha256 cellar: :any,                 x86_64_linux:      "278dd9146c399589e0fffe02f93811188826cc7b6590fe7db6e72d3780ccc4f1"
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
