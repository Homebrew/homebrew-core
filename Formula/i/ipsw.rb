class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.747.tar.gz"
  sha256 "fa018b8fc1ec3f9f153bc484ac0ae676961df87be10f2eb6ac32dce757868b40"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "841ddc5dc8e372d8773ecf04ea5a418d407859fdf9a796cbc674b3bb89b41d44"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc7e07d72158c149ed8d1b95c1b8f0960b9393de37b08b474d1788cf4c18c44b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e66d7c4775005a3eceb5016b756c05d60482d970f2c33a264263783ba6319de8"
    sha256 cellar: :any,                 arm64_linux:       "c3ba65a5042d4ffddfc28cff26ae2faa46dabf1f35f599159261f157377b5cfe"
    sha256 cellar: :any,                 x86_64_linux:      "0cefc0b54cc5fd2286bd6d685971f797544bfe7421d6a88999f18398967ffd29"
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
