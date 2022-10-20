class DroneCli < Formula
  desc "Command-line client for the Drone continuous integration server"
  homepage "https://drone.io"
  url "https://github.com/harness/drone-cli.git",
      tag:      "v1.5.0",
      revision: "92e84c4e2452f82ad093722d87ad054e1821805e"
  license "Apache-2.0"
  head "https://github.com/harness/drone-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7db30f414e4fed8855cdf0ebfd23704ca5d98481c1e4b9cce1c432c818c39c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3fa702e5a13f34f1dc989c216b84147ad896112fe503932aa34d5b911157a73"
    sha256 cellar: :any_skip_relocation, monterey:       "0acbad2a3c296d8c07606aff9f246675fe04bca6e801900ec26b4b9a310d3690"
    sha256 cellar: :any_skip_relocation, big_sur:        "65cc3a62fabbb34266675510fa01c9a924b3aa158231404d6ed440e519fc0b97"
    sha256 cellar: :any_skip_relocation, catalina:       "cf0e94994336f4345837b93628ab2b70e17211eccd7d581eb2704469307597ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6ed05521633d4cb92588ad4adb811f2c86ecd0c388f01b4cc2de183af643f55"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o",
           bin/"drone", "drone/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match "manage logs", shell_output("#{bin}/drone log 2>&1")
  end
end
