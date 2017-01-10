class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line."
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.40.tar.gz"
  sha256 "0ce7271c3c9dfe51810b5ab7683c27510e50e6848a3d7d90e97a052016ca70f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "4437f2afc8a15746f351149db1877e0a0c46aa3b056a220c255d4bee5ca5ba62" => :sierra
    sha256 "a4b976a5929cdae3763061a2bacd4c36f1db2aabc10ff07eaa2032e042a9f8fa" => :el_capitan
    sha256 "dff635e056ebb7e50dedc9aebd5bc0240f64c7ed5daeab3afe4edced3aa717ec" => :yosemite
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
