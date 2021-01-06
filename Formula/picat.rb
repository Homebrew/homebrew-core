class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat30_4_src.tar.gz"
  version "3.0#4"
  sha256 "125f1b4fc932a99833f5ea7d839ca9dc4c211fca02ea50b68022da5309b191e7"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/updates.txt"
    regex(/Version (\d+\.\d+#\d+)/)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cebc62f081eec861ae329b8e2b9daddc1c82286e3d82f9f0d699fa0b124ecb7b" => :big_sur
    sha256 "5c5c7429d633369628acd7d1e0946cf60e8ef4160a158a9344dfd3d4c3e89b07" => :catalina
    sha256 "842f803d6cf22c236c2e514c56a0cdd585b9b71c8a67d165bd56783d4c83a0da" => :mojave
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
