class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line."
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.44.tar.gz"
  sha256 "03a30014b28f815ec7703f1207a458fdaea07dd73f83723de83289e36e9a333b"

  bottle do
    cellar :any_skip_relocation
    sha256 "373db2b5efe30d0b96cf08722dfcbcfe32ff3c2936f6a825805dd1ae5d96b4a0" => :sierra
    sha256 "bef37b0ba0844af89122d8c01b765c99dd25058d37c4e33bceefc2ee5c74245a" => :el_capitan
    sha256 "9502d27d602d1efec06174a0d3df617a02ab9968b308d5ea4ce5d2a5af2a7508" => :yosemite
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
