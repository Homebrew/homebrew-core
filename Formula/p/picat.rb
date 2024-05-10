class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat366_src.tar.gz"
  version "3.6.6"
  sha256 "9314b162b45ee17caaeee57202b0a4a4c9168534cdd4bbe74e5535672a1787a5"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1bce8c405d66161c62384abe5198480976d39928d05424787c397ed23485e5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7bd7b73673f50222aeeb2c7e228c4f765568050d8d00a2770b83b931429f8fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abb7e38ced0679cb1a885ee3b707e2a766849d18c5ed3cf1cd16c5c0ec46822b"
    sha256 cellar: :any_skip_relocation, sonoma:         "526584357d8fb6e1e60bf02bab32884230c17a30b42772779bc2f661913bcccb"
    sha256 cellar: :any_skip_relocation, ventura:        "3892abb739c793d5e147edd90bcc1f7d5cd1fce9d54b991a4f94ea6ffa3b4125"
    sha256 cellar: :any_skip_relocation, monterey:       "157393f9051003e88886ead4a668d53e516951a052b3f4f11579a0e55518d529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1baf04338db7f28c7ab6ba31d977f78f6cd8197241c866c6633af7b951afd897"
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
