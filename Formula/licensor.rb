class Licensor < Formula
  desc "Write a license to standard output given its SPDX ID"
  homepage "https://github.com/raftario/licensor"
  url "https://github.com/raftario/licensor/archive/v1.0.2.tar.gz"
  sha256 "c8531a119fa6d633b7ac569308a074c57fda757113789bd5039b9f1aa2917889"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match "GNU GENERAL PUBLIC LICENSE", shell_output("#{bin}/licensor GPL-3.0")
  end
end
