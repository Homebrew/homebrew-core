class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Golang"
  homepage "https://github.com/context-labs/mactop"
  url "https://github.com/context-labs/mactop/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "dc5ec6cbe74ddae95bfdc8bf8da1b447b1924c10e90cfc3acb82ec8738ba557c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "32397b3f6e0d5efca5ba5c1bc92b877a8771c8751f2f3a9e95c5f515c668dcc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "708bec6a72c64f63b7f4afff189ec074b742614b4bf4573e8de9d82bbf2abb06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f2cf7e9113364464d7c74ddcf1c90e87d0189ad841830c50f4fede2e7e690c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54d5347f41c463d40a8ddac94deb165130b32cfdea8b2ab1c50973db8bd1c43c"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def caveats
    <<~EOS
      mactop requires root privileges, so you will need to run `sudo mactop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end
