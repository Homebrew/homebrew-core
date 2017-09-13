class Q < Formula
  desc "Treat text as a database"
  homepage "https://github.com/harelba/q"
  url "https://github.com/harelba/q/archive/1.6.3.tar.gz"
  sha256 "56d5e15355ebd021b9e3affef919a017eac22858ba22896eccba181072811843"
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
