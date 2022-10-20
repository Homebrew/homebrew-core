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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb15b9fc5cd72a1655e835bbf7539b44c4d06aae826374b4b9facd0d0f185901"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ea1072e34b8d14bbe64a3622c76a8abd71fdfcdfcf477b2f8334159b4b42433"
    sha256 cellar: :any_skip_relocation, monterey:       "7a62131b226b15b0eb792895a9f1dc0e5220dd045a929ff39d5a7d660f890762"
    sha256 cellar: :any_skip_relocation, big_sur:        "451b2e2431baa3d77a34ef1a9779bb574a7193674ca3970749ca95d073b12b09"
    sha256 cellar: :any_skip_relocation, catalina:       "69189ead9fd784662f8422de508885de6aa9a8594551551a374f2a7700fa7a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b0f858e04946742e6b2ad741cc9a0e02d8c302cdf1d285d74e6b1267fb0e7fe"
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
