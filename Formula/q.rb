class Q < Formula
  desc "Treat text as a database"
  homepage "https://github.com/harelba/q"
  url "https://github.com/harelba/q/archive/1.7.1.tar.gz"
  sha256 "cf0f2ca3ecb88fedf6232d5ce5931afc90eae1db8fdef78b17933d46e9f9f678"
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
