class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.634.tar.gz"
  sha256 "e18610f865eac8a51915caa9c36fcd63b5b5fb07e33d1675dcf02253e0e42d9b"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "009680988a28ccdff3b875fbfd40f731dec95d3c076965c32ab64b47ee160c01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a406b737d91ef407c6628a8bc9a61612574c204f8746818f59c9b49fc8978ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "576ffaff5e2daa36b8ae5eaa70cf4d46b67790871e16ac9f3c293adcad092dd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c45c132b5984daf37fab42a48d75e7ffe0a065dcfdb56c4be79e157a52b088e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f14cfaae125540203f8b5e10e894a1803966449f2c93dcb41314b993c0634ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ecca6eb44d972e340b0c7efeb31dc9266b014d8c260c993078fc63befb6343f"
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
