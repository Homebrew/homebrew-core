class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat311_src.tar.gz"
  version "3.1.1"
  sha256 "e2d3a0948158bf06c32fd1e7f696c27ff9a51033521d56ea9b03132f0b6b52ee"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "22c2c064be90b74c688624489235f5d9a7c5ebd93959375e23cb46d489f26390"
    sha256 cellar: :any_skip_relocation, catalina:     "e0a229962d20f09a7525c69e2c14ffbdbdccf241a3cb10e6eeb160f3aeef55f5"
    sha256 cellar: :any_skip_relocation, mojave:       "83dbcad3ee2643c24cd3042767feff55405e33876e28968ff2211fb621a1f3cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ee36d840a66edbdb8e79604b9d5933344376f3d894c6f67107efd7f9e63aa3fe"
  end

  def install
    makefile = if OS.mac?
      "Makefile.mac64"
    else
      ENV.cxx11
      "Makefile.linux64"
    end
    system "make", "-C", "emu", "-f", makefile
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
