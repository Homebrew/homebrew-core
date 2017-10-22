class Clac < Formula
  desc "Command-line, stack-based calculator with postfix notation"
  homepage "https://github.com/soveran/clac"
  url "https://github.com/soveran/clac/archive/0.3.1.tar.gz"
  sha256 "38cf86f99959d2223f052acfd9e0fecb402a137ebf859a9c64a541b15396e32b"

  bottle do
    cellar :any_skip_relocation
    sha256 "47fcb34fd72b29618f56fffcd571541c1e799e7066807d130af6723dd5615af1" => :high_sierra
    sha256 "0b3dfbfceadc4fd035b932e0d84437f0c35fb50001ecf33bf2d39732d9c41fd9" => :sierra
    sha256 "495572ab079dd58563888ce31af20269497802f670429036bc41578bf9d90c8a" => :el_capitan
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_equal "7", shell_output("#{bin}/clac '3 4 +'").strip
  end
end
