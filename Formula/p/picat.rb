class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat36_src.tar.gz"
  version "3.6"
  sha256 "0e33f57232b144bc4c8e21e6617e36fa4686e7fff4f48acf21cd4eef980b03a9"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5aa42d8b5e324977661d9d2926003d861da31630e6ba66d8419b23ab66857299"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "992da7b96e35a7171a2b1258ef905b1e254a3036c3d3bb939941c4504968960c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d917e7ff0cb9b2c54abe6d7dc54e63aab47261ee0e94e666d13238231fee3f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd993bbfb960754041ca23bb930febe44cde589b959a1b602dbc2701bd87d737"
    sha256 cellar: :any_skip_relocation, ventura:        "164b18f8541398c4c01e06e658cff45d6825f7c7308b97cd798b8bcaf8eabfda"
    sha256 cellar: :any_skip_relocation, monterey:       "0c114f7b384d07481d87df5d7b79dddc8133daf75a6ec2d7732d0022e2404221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08e9052e00162f5de3f56a0ffad4ea7086a0f7c1f12657f6aa12ece9556761c4"
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
