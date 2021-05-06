class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat31_src.tar.gz"
  version "3.1"
  sha256 "093ca00f74a67a70ed8c5e42f3e3e29a43b761daa3cf9ca7d6bb216c401f4e72"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "0b46597446fbf2a89bcf167c1074130adbcd78224c0abf730549dd1276294e06"
    sha256 cellar: :any_skip_relocation, catalina: "9333c71b38ab368a6cf59aff288a941309f464922323066f060ebdc9767def27"
    sha256 cellar: :any_skip_relocation, mojave:   "45f854d102acb4e041f176049552072b8a34f7b586af655cc28053688b151670"
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
