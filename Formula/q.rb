class Q < Formula
  desc "Treat text as a database"
  homepage "https://github.com/harelba/q"
  url "https://github.com/harelba/q/archive/1.7.4.tar.gz"
  sha256 "97a21907e4599bfdc8937ee4cb4d7e899c45ae09ae8d3c96235efa469e4f2ac3"
  head "https://github.com/harelba/q.git"

  bottle :unneeded

  def install
    bin.install "bin/q"
  end

  test do
    seq = (1..100).map(&:to_s).join("\n")
    output = pipe_output("#{bin}/q 'select sum(c1) from -'", seq)
    assert_equal "5050\n", output
  end
end
