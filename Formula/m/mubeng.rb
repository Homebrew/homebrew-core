class Mubeng < Formula
  desc "Incredibly fast proxy checker & IP rotator with ease"
  homepage "https://github.com/mubeng/mubeng"
  url "https://github.com/mubeng/mubeng/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "97e439a5bbc71e68b804dfdd5492161f436b32052979cc8dc8b44b71746d046b"
  license "Apache-2.0"
  head "https://github.com/mubeng/mubeng.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a56d9d78fbdea2280c92a638a03b15fb834f3b50134eb12553c9b58e4e11451"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a56d9d78fbdea2280c92a638a03b15fb834f3b50134eb12553c9b58e4e11451"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a56d9d78fbdea2280c92a638a03b15fb834f3b50134eb12553c9b58e4e11451"
    sha256 cellar: :any_skip_relocation, sonoma:        "182a68463d78f16d2d2c9f89a404a588fb42c8c0afe4cb818f434a5c6cea4281"
    sha256 cellar: :any_skip_relocation, ventura:       "182a68463d78f16d2d2c9f89a404a588fb42c8c0afe4cb818f434a5c6cea4281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad0c574fda0313c6dfe08fbc653c2ccea8829f087ddc37b6d5545c39751e7be8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/mubeng/mubeng/common.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    expected = OS.mac? ? "no proxy file provided" : "has no valid proxy URLs"
    assert_match expected, shell_output("#{bin}/mubeng 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/mubeng --version", 1)
  end
end
