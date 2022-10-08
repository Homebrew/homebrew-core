class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat333_src.tar.gz"
  version "3.3#3"
  sha256 "2cc9801c218a8289ffc0d6eb5d3507f61887c86570c120e9075db7eb16b0cd7b"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a34cffaa95bc605ddb89c4560cde5cdc795bfc01d8fdf28302ee46732ac4ab5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa2018b05cf8ddfdb210f4774cc0dae915433ba8a125abbae7f29ec8fe795356"
    sha256 cellar: :any_skip_relocation, monterey:       "f964f0943fd746220559619ea4b92a43a672d914da9c0b436a6533e4eaae6e20"
    sha256 cellar: :any_skip_relocation, big_sur:        "31660c425f970d6c566a22fcf8ed4da743f4dcdd35298522296ef3729bc10afc"
    sha256 cellar: :any_skip_relocation, catalina:       "37b3ed73990e520bd5fe199a7b5d774f65a978b0ada6a3c6f74ccdedc9d5e654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d78aa95a4d56bc2b712005047f177d70df2d4cb0dc10b468ea1e90efa408e453"
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
