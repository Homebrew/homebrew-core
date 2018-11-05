class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.51.tar.gz"
  sha256 "fac4ab7716985c3e2a13ab2dc43cc8521e756925d3149c430cef2d79d34eb7e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "672b773f3fc4ab3aa1447ceadcc14cd394944e3b7ee7b932839a98e318d0d8af" => :mojave
    sha256 "59415efda86bb2c5474ba8539108813a2970c5863a1a9eb9f634cbd911a2a41d" => :high_sierra
    sha256 "5f60ed2583d232fb65f6900f23ab1ecb99ffd1812948b288d87836f221da3e08" => :sierra
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
