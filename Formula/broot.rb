class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.11.3.tar.gz"
  sha256 "d498b911e4f7cc936a705a28653a0d7a7183c80ef093fd7e738403f3388f6322"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6fa0d431eb939baf3260c436c37a273e68fc0ca26ae3a320f6d5df84171d50b" => :catalina
    sha256 "86eea9278e02f9888e1bc5c80342579620a696cc50d1aebe54416b1f98cc0b94" => :mojave
    sha256 "242b5c4c68e6db4ec8624f80b610607f69f17d729ec2b990f8af7caa1e86e6b1" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    require "pty"

    %w[a b c].each { |f| (testpath/"root"/f).write("") }
    PTY.spawn("#{bin}/broot", "--cmd", ":pt", "--no-style", "--out", "#{testpath}/output.txt", testpath/"root") do |r, _w, _pid|
      r.read

      assert_match <<~EOS, (testpath/"output.txt").read.gsub(/\r\n?/, "\n")
        ├──a
        ├──b
        └──c
      EOS
    end
  end
end
