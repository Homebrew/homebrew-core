class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/metaspartan/mactop"
  url "https://github.com/metaspartan/mactop/archive/refs/tags/v2.0.9.tar.gz"
  sha256 "e81e8ffda86bfb78f6eb1aa1e812264bd3625efc05390c6edba9a42fa7c8ded1"
  license "MIT"
  head "https://github.com/metaspartan/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d2415afd9d49d78be2ada8f542868d7d797a05c8b208a6c4f186e4d2d64988e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff6bc6a980b3c5c697851c505119898518dd89f63ca6d453fb91ecb34d65c0e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84b035d205540b6cbbcabd57f4a776c44711e025c9055e581f5505ae19551bd0"
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
