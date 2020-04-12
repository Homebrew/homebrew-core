class Q < Formula
  desc "Treat text as a database"
  homepage "https://github.com/harelba/q"
  url "https://github.com/harelba/q/archive/2.0.10.tar.gz"
  sha256 "c6f96263d32f6facaa34480c6d4c91a356cefdc3edf7f271ec3efd505b20532b"
  head "https://github.com/harelba/q.git"

  bottle :unneeded

  def install
    bin.install "bin/q.py" => "q"
  end

  test do
    seq = (1..100).map(&:to_s).join("\n")
    output = pipe_output("#{bin}/q -c 1 'select sum(c1) from -'", seq)
    assert_equal "5050\n", output
  end
end
