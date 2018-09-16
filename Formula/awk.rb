class Awk < Formula
  desc "Text processing scripting language"
  homepage "https://www.cs.princeton.edu/~bwk/btl.mirror/"
  url "https://github.com/onetrueawk/awk/archive/20180827.tar.gz"
  sha256 "c9232d23410c715234d0c26131a43ae6087462e999a61f038f1790598ce4807f"
  head "https://github.com/onetrueawk/awk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e924a14afca65c45751bc294926f2034a0a67e50fcd22303e31ec8196a8b7a1a" => :mojave
    sha256 "da4358a83f3e939323eea96b4dc4db74a71157bd7d702b9599811a54a393e26c" => :high_sierra
    sha256 "40dbcdf8549b662e7775074fe8c172f364862705b0c0ba00495c2da6e1440a70" => :sierra
    sha256 "593cdb489ae25ec556af3a02e26b957efc3a67731f8edf48335a994fa58d533e" => :el_capitan
    sha256 "d74b6dc04cd9dac3791216744a56813b8396c419f325244526c79c433ca95b3d" => :yosemite
  end

  conflicts_with "gawk",
    :because => "both install awk executables."

  def install
    ENV.O3 # Docs recommend higher optimization
    ENV.deparallelize
    # the yacc command the makefile uses results in build failures:
    # /usr/bin/bison: missing operand after `awkgram.y'
    # makefile believes -S to use sprintf instead of sprint, but the
    # -S flag is not supported by `bison -y`
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "YACC=yacc -d"
    bin.install "a.out" => "awk"
    man1.install "awk.1"
  end

  test do
    assert_match "test", pipe_output("#{bin}/awk '{print $1}'", "test")
  end
end
