class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat35_src.tar.gz"
  version "3.5"
  sha256 "5fa83207440c33d41faa6adc7716fe3e70f7506914a5c7dba22cf953201f49c1"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b27f6c8a317602a0edc238643af54069a887b974059cc131a8170ef46efae707"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bed63f6e2984701a1c6cd424c6137dc7429d834e97eb75a817446d78d42200c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c9b492db793e51ae4537fdd487b695e97c6e491524b5cae9e36895aaf7ca86f"
    sha256 cellar: :any_skip_relocation, ventura:        "cccc0ac2a526496bc605a96c5440e3a9abb62fcb38276649af3cdbfeb932bb08"
    sha256 cellar: :any_skip_relocation, monterey:       "d1921260b1d0def09d1899960cb68323e0399d3d37617caf2fc4839101fd67de"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ffd8f7cef4d47b5ceea42a3c930f2e3294b1b488cba208dd4708ce229597165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed337887005f753d95e2d215ad6bc56595332c30b7badf9095296b55fe738ca2"
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
