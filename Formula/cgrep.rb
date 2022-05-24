class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.7.1.tar.gz"
  sha256 "ba38c17ad5e6601c5d6bec371940898b713f74c910f755f5f743a52998ac5efd"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dc1dfe6ff0a88a1e8780ed1079c33230f78082ba4434c990d8a8cfcdf76ef89b"
    sha256 cellar: :any,                 arm64_big_sur:  "ef954d3f2e1879f05a667b23aed866f2db7d87984ffe1d6402a35a2328f13454"
    sha256 cellar: :any,                 monterey:       "71686413fa2c85c8492b5abe85fb479d052005a18ebf90eab05da083d7ea3bf6"
    sha256 cellar: :any,                 big_sur:        "3518bc205f0ddf5b4944b92360ba3980aac3b76f63731b31c1c349fca9bf548c"
    sha256 cellar: :any,                 catalina:       "2730977f95916aaad571374e3432b059e1b9d9910fe840e31e37471a6288f0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e7152c7dd442a3c0ba0c4ea55fc8f46348bd3733b6e17f2b0472a5baad2ab7a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"t.rb").write <<~EOS
      # puts test comment.
      puts "test literal."
    EOS

    assert_match ":1", shell_output("#{bin}/cgrep --count --comment test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --literal test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --code puts t.rb")
    assert_match ":2", shell_output("#{bin}/cgrep --count puts t.rb")
  end
end
