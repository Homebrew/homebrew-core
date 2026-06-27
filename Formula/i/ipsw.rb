class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.700.tar.gz"
  sha256 "4a2f85f5b1efcc9e857ebacb935bf12ff98b5e9377779d90563c47954c90c99b"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92e359f1e09871d5f6ae7d70ed3605e2564974e6bacb726e23a108143a746c2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af952542f9ccf9240f2f9b6eb6b837c480a6e55cca31006b0d59e9107dc0c44f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fc89231d8c82303daaf52830910d6339c20bb3d124ceb1857633b84a38eb719"
    sha256 cellar: :any_skip_relocation, sonoma:        "76e25bc5692ed83a56e10ee0d44115dc432735db85f1977482eb2cdb4e809bf1"
    sha256 cellar: :any,                 arm64_linux:   "92675a70fb36d7b6ec00984f77dfeb887dcc25ee54173f2169e10296f4cd3201"
    sha256 cellar: :any,                 x86_64_linux:  "1baf77952cf4b73d16a74119ebb99662433d3acefedb3252e0d552162c53b869"
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
