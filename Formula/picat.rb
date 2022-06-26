class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat320_src.tar.gz"
  version "3.2"
  sha256 "b72edbb3b81e1e74f6a5dc994587a2b0fe2b3ed123d809ca0fd6b0c171bcbbb0"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "1f33bf6c7ae83490260df3703be639f24c02d2a86fb28b689de981e8c53eecad"
    sha256 cellar: :any_skip_relocation, big_sur:      "ba375b86a0e972b1d0b23eea30507c4103456c6a3d37dc838ac96d3f6d52c515"
    sha256 cellar: :any_skip_relocation, catalina:     "aa7d37c3007a693e4a48926cda378833add85084698f57dadf193c9e04494145"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "56f52e028eed98e9d09609ea7536d33a2e8cb7dfdd712454ca097a86ee967762"
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
