class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat24_src.tar.gz"
  version "2.4.8"
  sha256 "72b452a8ba94d6187d837dcdb46aab0d7dc724651bac99a8cf2ada5c0a3543dd"

  def install
    # Hardcode in Makefile issue is reported to upstream in the official Google Groups
    # https://groups.google.com/d/msg/picat-lang/0kZYUJKgnkY/3Vig5X1NCAAJ
    inreplace "emu/Makefile.picat.mac64", "/usr/local/bin/gcc", "gcc"
    system "make", "-C", "emu", "-f", "Makefile.picat.mac64"

    bin.install "emu/picat_macx" => "picat"
    prefix.install "lib" => "pi_lib"
    doc.install Dir["doc/*"]
    pkgshare.install "exs"
  end

  test do
    output = shell_output("#{bin}/picat #{pkgshare}/exs/euler/p1.pi").chomp
    assert_equal "Sum of all the multiples of 3 or 5 below 1000 is 233168", output
  end
end
