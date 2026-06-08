class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "https://picat-lang.org/"
  url "https://picat-lang.org/download/picat398_src.tar.gz"
  version "3.9.8"
  sha256 "af29d841b2e10b7685ea47766bf348fbfd5e1cc9ff1839d3d5074f334e5140b2"
  license "MPL-2.0"

  livecheck do
    url "https://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "129c76ae7a24cfc764dd2ece9f878dbad746fc292e1e15d3b58a685e28fd5114"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "156fc1c37ab2d7bc9847ec37710f6dcbc5fcf7401815e33b827c08628856cf55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f6b9cf8af4c87b27196ce38874472c6f9cf6f2f11bacf7b079cc0a59ae3f5d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "81cbc7e4250a8ec3d1ba203991957b166b414a4902bee53ba90f7309f801d42c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52f256ed9ce831fd3c55db6e21453cb46410f833f457d73483589f551e36951f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdef33f26815449e9f2c2bb15c2cd24a3aee68284e0350e63646563dec09c21c"
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
