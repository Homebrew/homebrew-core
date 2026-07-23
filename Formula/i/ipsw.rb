class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.705.tar.gz"
  sha256 "e41c51b1156c28ea9e18a97335a132203acf83d815c0420c9131394df1122b65"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40adfca4c16c6410f0f3df64105abbe28ba85fca20c0e9415e0e043df3379c81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83ffe0c8b7492b75059b5578a69ff64ce2435626fc4484a506a9c09d1fa7c12e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d783b75003a8bbcaa135e8297ca435ae80116f1f41008f39404245998b07026"
    sha256 cellar: :any_skip_relocation, sonoma:        "2487608f310c9cbb2adfecfdacdd7a82e90577a1fea3da96f593e8588eace7b5"
    sha256 cellar: :any,                 arm64_linux:   "1d5d2a44bac72138dc698fbcab930f462325121b618c436806dc424290cc73b8"
    sha256 cellar: :any,                 x86_64_linux:  "1d191ce1670477f3f241e5dc575bd1fb9c075330008b24e0c8fc1c289424fde2"
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
