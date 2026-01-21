class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/metaspartan/mactop"
  url "https://github.com/metaspartan/mactop/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "e168276bd4be21fa9fc2d6b26dde6279261343d4a53cfcf3c76b7d5083cf0691"
  license "MIT"
  head "https://github.com/metaspartan/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8454ed378295f2f23f8b9d5e0b0f749ee49d71509e4c557b4c4c5333ca35848"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "681be53c386e7b669ec3ce9cbe6218a5fdbb2d8779944c3b1cfd5f2e4dfc5661"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8392d710c0cd3d7c4bad670ea6ee339efcb247912b2c7ed0d3d03befa5773b9b"
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
