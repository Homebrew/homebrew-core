class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat30_4_src.tar.gz"
  version "3.0#4"
  sha256 "125f1b4fc932a99833f5ea7d839ca9dc4c211fca02ea50b68022da5309b191e7"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "73253b90dec9024d0c9c035488314f78af4fbc469528fe6c1056cc6d733847d3" => :big_sur
    sha256 "4d90c10fb6dce3de3ac942f7e9c659ce88490b9414e041a6d8d205b950c8e058" => :catalina
    sha256 "905dbeb4d7a5ae69043c64fcff70474053d6084d6148e253aee6f3018e3c5d74" => :mojave
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
