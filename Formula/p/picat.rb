class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "https://picat-lang.org/"
  url "https://picat-lang.org/download/picat39_11_src.tar.gz"
  version "3.9.11"
  sha256 "a605e9b181aa933afad15ce69b696c1a3a8bb5b7640738ae1a2461c0b740f14d"
  license "MPL-2.0"

  livecheck do
    url "https://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a26cca61e7889ee9f2d02a1fe784ad7418371f124bd303b46ec7744a787e9a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c6df3d0189ec387829d19c3d246a53a7967142969c5a3dd8dd4f1d3c72aa40f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cf3c6ae6b17ad5bb3ee4b32227f923f7af2df72ed7e19bac2d8533263e33d1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbcdca4558b34ea8ce6ae06e65c15aafd654fd68a60c920e44ce21a1875fb176"
    sha256 cellar: :any,                 arm64_linux:   "bbefff9d941d651cf2fc7ad28831ce2226b1766766b6987f9571c19dc4dcbf81"
    sha256 cellar: :any,                 x86_64_linux:  "d9e2166ad195cc1e3f0c2f0679f44333ef9f899d0cd85e5e24ef317be84d9f16"
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
