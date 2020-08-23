class Q < Formula
  desc "Treat text as a database"
  homepage "https://github.com/harelba/q"
  url "https://github.com/harelba/q/archive/2.0.11.tar.gz"
  sha256 "f0b88809d0b1f35ba7a8df5d2d86af12d10cea9e64eb554d3b7f8a5fe886d875"
  license "GPL-3.0"
  head "https://github.com/harelba/q.git"

  bottle :unneeded

  def install
    bin.install Dir["bin/*"] - ["bin/q.bat"]
    bin.install_symlink bin/"q.py" => "q"
  end

  test do
    seq = (1..100).map(&:to_s).join("\n")
    output = pipe_output("#{bin}/q -c 1 'select sum(c1) from -'", seq)
    assert_equal "5050\n", output
  end
end
