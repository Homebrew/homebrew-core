class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat26_src.tar.gz"
  version "2.6.2"
  sha256 "eb70cf7b1796812e9398077156abd7b4558130cb913ee9186f3625869184c651"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f65a7f14dc8aae1a1c680c9bcabf79f283581def0349564d2a4aa34cdbb0a63" => :mojave
    sha256 "950628799e8fe03c6c70b5f54e4658502429e7e5c067a230d2e14f0066ef05d2" => :high_sierra
    sha256 "1260179d1a7beca07fb71423f0a2d8d1b6eacf338ac1aafd077caaa49139acd6" => :sierra
  end

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
