class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.751.tar.gz"
  sha256 "8439bbec60f2526bd6e103e853bc9e0306f9794cfc1a0f7a9b6fb9b39862de44"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "40e9a282e087a75e0ede9eb271dc17f5e3fc384de392747f3748fbcfb7b4d580"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "90ca632e8f291339798bc82812794736568eef58b43466699b7b0905dba27f81"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d9e974d5c2f055089aa774d304f3a15f0c640a3237be760ab93425f164f29f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6cb83a596ce2c794db9978fad8a49c8d54f117ff0624ff7e3f8c98a93413d06f"
    sha256 cellar: :any,                 arm64_linux:       "d3fdcc7eda4ace5aced3c3cf82f63a8e64e83b07832acde07b2fb00079301da8"
    sha256 cellar: :any,                 x86_64_linux:      "78f31b419eab0583a4ec39045371069271ceefa2c572e9649cac73aa8147dd1f"
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
