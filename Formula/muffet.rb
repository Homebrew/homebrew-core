class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.6.1.tar.gz"
  sha256 "3b457afa53990dd5fffbbaea138ec553e4be96caf2d196fece1ddab2ee4a3d57"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "318dc184a2700b19a8e7a4e38b32e74145c4255633359e647620b47e6c3c2df8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e814d351a90a303b849f2f68f4f68f0b685eb264ab7e75e87b67b4e92ca6002"
    sha256 cellar: :any_skip_relocation, monterey:       "e1e7d66d8c352db839fff5e36dcc60c74e4e2976eba2453104dbe645082f0221"
    sha256 cellar: :any_skip_relocation, big_sur:        "c601ba27142a26528cbba5327c653e4a56d64d12499798e93c56ce4e14c8f862"
    sha256 cellar: :any_skip_relocation, catalina:       "f211186f708a101ac44a3b3ce1e5e8e1b613f00f8f103c4bc214046176afa299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0de377982faeb8c3f3f526301f78a7715269a30441bda10dcc4d7ab9ecd77c4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://httpbin.org/",
                 shell_output("#{bin}/muffet https://httpbin.org 2>&1", 1)
  end
end
