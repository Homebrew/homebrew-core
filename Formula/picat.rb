class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat28_src.tar.gz"
  version "2.8"
  sha256 "79d8ffe8570856db40b0358688b268ca3ee5f1c0fe5fa90cc7260d411ef29e0a"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f65a7f14dc8aae1a1c680c9bcabf79f283581def0349564d2a4aa34cdbb0a63" => :mojave
    sha256 "950628799e8fe03c6c70b5f54e4658502429e7e5c067a230d2e14f0066ef05d2" => :high_sierra
    sha256 "1260179d1a7beca07fb71423f0a2d8d1b6eacf338ac1aafd077caaa49139acd6" => :sierra
  end

  def install
    system "make", "-C", "emu", "-f", "Makefile.mac64"
    bin.install "emu/picat" => "picat"
    prefix.install "lib" => "pi_lib"
    doc.install Dir["doc/*"]
    pkgshare.install "exs"
  end

  test do
    output = shell_output("#{bin}/picat #{pkgshare}/exs/euler/p1.pi").chomp
    assert_equal "Sum of all the multiples of 3 or 5 below 1000 is 233168", output
  end
end
