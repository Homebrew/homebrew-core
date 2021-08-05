class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat31_src.tar.gz"
  version "3.1"
  sha256 "c1ae1491d56e643693aa806c08c221d2cf0d59de1ddd8c31bcff1c917c979542"
  license "MPL-2.0"
  revision 1

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "7e44278692b3be42b8e016595ea1c50e5a8cbd2d62cd729f98179bdf1a602d25"
    sha256 cellar: :any_skip_relocation, catalina:     "1aac88c44c248917b484c85e8d0cebbd015fc95133948b40d728d6e96d6a7cc2"
    sha256 cellar: :any_skip_relocation, mojave:       "42eda2841fcdf3d5b6b1e7db6c15818cb6548d567779a88cb58e9e9286291689"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d5567ae2a20c22c4f1d329181d189c1bdbe16d03bc9110c83b20eaf0e8f76e8d"
  end

  def install
    makefile = "Makefile.mac64"
    on_linux do
      ENV.cxx11
      makefile = "Makefile.linux64"
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
