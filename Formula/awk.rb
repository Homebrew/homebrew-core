class Awk < Formula
  desc "Text processing scripting language"
  homepage "https://www.cs.princeton.edu/~bwk/btl.mirror/"
  url "https://www.cs.princeton.edu/~bwk/btl.mirror/awk.tar.gz"
  version "20121220"
  sha256 "8dc092165c5a4e1449f964286483d06d0dbfba4b0bd003cb5dab30de8f6d9b83"

  bottle do
    cellar :any_skip_relocation
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
