class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.49.tar.gz"
  sha256 "5cb292761228309794cfecb7105232559433ceb1f16a5a5f80ca08ee8caf9902"

  bottle do
    cellar :any_skip_relocation
    sha256 "33db12a4bdcc89874062b1c591cedb3e44c61013eae0363ce2d5f1d1e68d7d04" => :high_sierra
    sha256 "6aa7778687e758c348d8e71351d0147d2b46df0668e699d1b197dccd927a28d7" => :sierra
    sha256 "835b905b32f65cfd4fe3a82e7ddce7d77536edc949a146bbdff79fce2cf69cce" => :el_capitan
  end

  depends_on "gnuplot"

  def install
    system "perl", "Makefile.PL", "prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/feedgnuplot --terminal 'dumb 80,20' --exit", "seq 5", 0)
  end
end
