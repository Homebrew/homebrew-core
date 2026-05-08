class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/metaspartan/mactop"
  url "https://github.com/metaspartan/mactop/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "34c8042bbc8ed7de5f8a7bab261d38f82135bde813a7ebff461bde434aed0cfc"
  license "MIT"
  head "https://github.com/metaspartan/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "804da266bd2c22df81f488ebd543cd0d37a2589bf1b6bffe40a30eadb2b748c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "174e967b57a2ab049f6029cf3a5d7e89d7d191cd1c06bffb4a69a4f82c84b4c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d418b436552cd695d7e063b4df1803d718cda42175e9891ce9f4445e77717037"
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
