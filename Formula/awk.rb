class Awk < Formula
  desc "Text processing scripting language"
  homepage "https://www.cs.princeton.edu/~bwk/btl.mirror/"
  url "https://www.cs.princeton.edu/~bwk/btl.mirror/awk.tar.gz"
  version "20121220"
  sha256 "8dc092165c5a4e1449f964286483d06d0dbfba4b0bd003cb5dab30de8f6d9b83"

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
