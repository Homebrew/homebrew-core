class DroneCli < Formula
  desc "Command-line client for the Drone continuous integration server"
  homepage "https://drone.io"
  url "https://github.com/harness/drone-cli.git",
      tag:      "v1.6.2",
      revision: "24bea58512640de52ef16c45f48645e255d8b46c"
  license "Apache-2.0"
  head "https://github.com/harness/drone-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11dcb730ceb63a5266e9adce96c536ec95f4cfb802170da6a27fdf027e26604e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11dcb730ceb63a5266e9adce96c536ec95f4cfb802170da6a27fdf027e26604e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11dcb730ceb63a5266e9adce96c536ec95f4cfb802170da6a27fdf027e26604e"
    sha256 cellar: :any_skip_relocation, ventura:        "741c93bc030a2b2aa751dd82496da58848f8a1d73edbfc35324d1d63f15b9ed4"
    sha256 cellar: :any_skip_relocation, monterey:       "2df78ddede5dcb72d53a4987adb9b0cf0f9389f57812c3cd1377addd19dd80da"
    sha256 cellar: :any_skip_relocation, big_sur:        "2df78ddede5dcb72d53a4987adb9b0cf0f9389f57812c3cd1377addd19dd80da"
    sha256 cellar: :any_skip_relocation, catalina:       "2df78ddede5dcb72d53a4987adb9b0cf0f9389f57812c3cd1377addd19dd80da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e80555d82d7af3039000e7ca28a465b1ed607a29ebc9cb291e5ea6a4611e9123"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(output: bin/"drone", ldflags: ldflags), "drone/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match "manage logs", shell_output("#{bin}/drone log 2>&1")
  end
end
