class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/metaspartan/mactop"
  url "https://github.com/metaspartan/mactop/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "3ebfacea4ad9e4f570a1425f02263cb2d76c6df24a2523ed7312ba42701d2468"
  license "MIT"
  head "https://github.com/metaspartan/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8eef1556f06b537034c7ef1fc844226e76f4640512c98b52cd05fa5363d79e21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5df5de342d3c799976de6803c76fd016145c9a2bfa77713fb6ed929e9cc17e38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a23ae4ca26601de341e06f50a59a0a7a5da7209e578666e9a3568fa740dd8f3"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end
