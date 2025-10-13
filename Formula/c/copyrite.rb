class Copyrite < Formula
  desc "CLI tool for efficient checksum and copy operations across object stores"
  homepage "https://github.com/umccr/copyrite"
  url "https://github.com/umccr/copyrite/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "copyrite"
  end
end
