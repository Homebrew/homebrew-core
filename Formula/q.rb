class Q < Formula
  desc "Treat text as a database"
  homepage "https://github.com/harelba/q"
  url "https://github.com/harelba/q/archive/1.6.2.tar.gz"
  sha256 "b2627b5b9b2941d7d3b206811cb6ffdaf5db73c66f541d80fbc74bfe14a0c881"
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
