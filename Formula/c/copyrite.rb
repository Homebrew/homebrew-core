class Copyrite < Formula
  desc "CLI tool for efficient checksum and copy operations across object stores"
  homepage "https://github.com/umccr/copyrite"
  url "https://github.com/umccr/copyrite/archive/refs/tags/0.2.5.tar.gz"
  sha256 "9907a4c13d9c91e7e4bdc71095980ce94ffce2eab9d00cfc151e5224a78e9108"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end
end
