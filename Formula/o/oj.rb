class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.26.10.tar.gz"
  sha256 "5f70b0baba7ca153ef123a8d392452038b69c0e155bcc15bf35bbc46d90ab0d1"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9728fbcdf4ae4e3f19b934c467aaa479d9b1b2c94b0974e0608cdcdd423fc8bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37de874893ae11677ca75532557bebd3dde8f1b9e9547dceae4a48e4858c113b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37de874893ae11677ca75532557bebd3dde8f1b9e9547dceae4a48e4858c113b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37de874893ae11677ca75532557bebd3dde8f1b9e9547dceae4a48e4858c113b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6a69759d965e5c8d079c7a4aab3b39e542be9551a021127a48b76a570e6267e"
    sha256 cellar: :any_skip_relocation, ventura:       "f6a69759d965e5c8d079c7a4aab3b39e542be9551a021127a48b76a570e6267e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61a38ba19e35e089be3f54a71e6f7678281a77d5f73f0ff3d5d45b422f86c7b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "433147b7f0b703a7fd269a2ba39b8b5656fa0fb7eacc6d8cf1cc4d82b2119f6d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
