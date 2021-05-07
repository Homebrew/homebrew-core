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
    sha256 cellar: :any_skip_relocation, big_sur:  "6e50d5fbc8c8ae11541653ad8a46f17c5a7c00b9949b446e167d2524e8edc1f7"
    sha256 cellar: :any_skip_relocation, catalina: "9230d26c90deef822d5d54c94bdfee12dd4b6d70130cca70eac02980f3c2ca97"
    sha256 cellar: :any_skip_relocation, mojave:   "a707f1d3ab71127d7ef235704267e076607abad53a3c129bc5cf0336af9adf78"
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
