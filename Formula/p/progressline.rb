class Progressline < Formula
  desc "Track commands progress in a compact one-line format"
  homepage "https://github.com/kattouf/ProgressLine"
  url "https://github.com/kattouf/ProgressLine/archive/refs/tags/0.2.4.tar.gz"
  sha256 "6649fa7d9b840bf8af2ddef3819c6c99b883dd1e0ca349e6d8bdb93985cb00fa"
  license "MIT"
  head "https://github.com/kattouf/ProgressLine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1ce512768f4802c3951adc6b2dd4add13a71d80ad5e04be15edecf17be6525a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77d1ab6f1922dbb9b14f3eed38fe30ddd33fdd5c058564389ec692af11e2a943"
    sha256 cellar: :any,                 arm64_ventura: "99959093aafeb1bd100e2f720fbfefc377595338d60e004e31f43b50204e5bf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d86284fddc430f9312ff6e74e0ecd510b6d0b34edcdcaca2c4645c4fbf8cd15"
    sha256 cellar: :any,                 ventura:       "1612ae0bb38a9f3a1897a27b87b14509527208e132d6a9d1c4c238bfd5d518ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e48df80a4b56abf1757d634986174db54dec6d74680a9d6bf65b3847bad0a3f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8429bc2bf925b50e2794b5e1a192e7a4bc896ea666cea8cd33c235a086872266"
  end

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/progressline"
  end

  test do
    some_command_multiline_output = "First line\nSecond line\nLast line"
    assert_match "✓ 0s ❯ Last line", pipe_output(bin/"progressline", some_command_multiline_output).chomp
  end
end
