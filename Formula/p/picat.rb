class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat368_src.tar.gz"
  version "3.6.8"
  sha256 "789c45e5ab6f26addf84596d7100864cffec81499fb1f0a8854826df1d94d67d"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "953168d1ed64438f004dfecbf0382ecad3ea734807e00dccf77f941ebbfcbe34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "755b4a81c3c98357146821c5615b020f14fac67291a908fbcb09ea56c1e4b80d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b14ea44f9a76910b70801245d3d2366593c8aa6fdd95d519b030faeb593aa5cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "11a816b8dd3bc8cd27b22e979a5caa3e26801d649f830f6911de43c397a4061d"
    sha256 cellar: :any_skip_relocation, ventura:        "9cb8c26996f2a7869f67ae29f72f3ef2e01177e4ee049ce8ab16897dd92e283a"
    sha256 cellar: :any_skip_relocation, monterey:       "81e0ea8ed94b0fed09916699c430017487938d56ef0cb338a5ffdc8bb7ff414c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be29a065c53951d63bd37863505e9cc573f06d3fab8deb9b3ade91bcb3c6c886"
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
