class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line."
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.38.tar.gz"
  sha256 "8470129f4de9a663702035f15f098766268044bd0052f2a4de5d662990c72d03"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d7cd15740fdb0f57cd0d27eec62e9ae9cda58aa71f4af1f4af182f233c7f0fe" => :sierra
    sha256 "8295c04f9a173025128d3df9e62ac84fbd5bce8d811580cdd8f0a6701b59866b" => :el_capitan
    sha256 "623969daaaa37d0fd141446a0925759a865ab8131152537d7e4918e976127d99" => :yosemite
    sha256 "fe66e806afeee86bf0e79929b9100db42ffef94421c7ad54248a4a241ffc2695" => :mavericks
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
