class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.739.tar.gz"
  sha256 "4c644efc9a3cb4d8f70699ace495e2dc79e17f88f761138ea5a6693d4aa1c94c"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f1c4894bfb8ec145c330e8404da005551d55062cb7632fd72c1208aea25f2779"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a16e46c29bc46cac225048af641219be3efe3d24b465b4d9f4947d99b709948"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc02ee4f9f4778c8ab3d2e62c387e3210e0eee61b738aeb30fd668a141a824e5"
    sha256 cellar: :any,                 arm64_linux:       "16606ccae765834ba39281238024e04afcbf2c415461aa55262d974148801ff7"
    sha256 cellar: :any,                 x86_64_linux:      "00c52549caf1668f73a82e28179d1b2af8f32d3176414590c88df745ca105b21"
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
