class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.631.tar.gz"
  sha256 "21ae4dca9324faaa3ddce622965355bce211a59160449077b59ec165e6758fb9"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe25fe505b1c5d972e7218684437698425d8d1466abcf4748c02345fd356f7e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03c1f1383760879f7119138fcfd54d97105fa17bfc10ab30210f3fca3c42ddad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29c0defbdd66a7ec784fc5dbff049d9697456608a31c11f249670e7a8bd24e9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf79916a19b8219fe7b589d42dc87dc16252add2819d4b279a26c2008b58e9fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e69c244d07a2b6b1f0a76c55ed5673f9a49e31e750ff49b78a7bc49478ce7422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef0a94cca4d31d36e481317f2a934adac03c8f52d65aa7bbe8cde759d39948c9"
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
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
