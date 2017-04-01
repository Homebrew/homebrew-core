class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line."
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.42.tar.gz"
  sha256 "0813f14917846c580f3bd1f1573b1ebf9b630a23799eb445cf95e4469fd4e173"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdd25ea4676e067b5815e44b876631dc87ea9f90b763586ac9113ce51ce74816" => :sierra
    sha256 "431cd0570df7a3648e6542819e9cc0367bf10c3431c74c64da89b08f3ed83c2a" => :el_capitan
    sha256 "2882bf4ed952df3f995b0c60cebf93ec4169e4811519321f9cbf14ec886914c8" => :yosemite
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
