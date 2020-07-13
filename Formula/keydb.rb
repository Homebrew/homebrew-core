class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/JohnSully/KeyDB/archive/v6.0.13.tar.gz"
  sha256 "e4b09babb9b95e1a2e5c8d7d898d63ea0badcb4b84a195239058484e91f820c8"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a2d66e4fd69d66c6d398a622a2faa3d3d4cf1e48b541a07cd29d707f0af50ba" => :catalina
    sha256 "0556a15e5bc0e1782b636e318d221142d0ed80bf74698cd60205b0fae1c9cc4b" => :mojave
    sha256 "9e9ab237fe2ca11d815652b4f8f08bc2bfe3b0054a3a1e59fe2b58f6659233fb" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/keydb-server --test-memory 2")
    assert_match "Your memory passed this test", output
  end
end
