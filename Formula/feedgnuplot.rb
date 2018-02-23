class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.47.tar.gz"
  sha256 "9c57d38a0516ddcfe641f043cfc51bc85af3b024343695b4f9df3ba5199c1388"

  bottle do
    cellar :any_skip_relocation
    sha256 "1122fcdb664608ba94c62d773fb4b9cbbc61211b3f94d2528939a443a2887cd7" => :high_sierra
    sha256 "ec7d1873b2a32d9dd29604a5c716c98693bcc83c00c7dc725a49264d524f04eb" => :sierra
    sha256 "93ecd7986b1bcd025042bf1379bd8511d13c4d3fd948b363db36a5d7fd820162" => :el_capitan
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
