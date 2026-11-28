class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "https://picat-lang.org/"
  url "https://picat-lang.org/download/picat40_src.tar.gz"
  version "4.0"
  sha256 "aad17a0a6051d783b4920d539cf7b652b0577f0a1e9ab8331f3d176f2abf29e2"
  license "MPL-2.0"

  livecheck do
    url "https://picat-lang.org/download.html"
    regex(/>\s*?Released\s+version\s+v?(\d+(?:[.#]\d+)+)[\s,]/im)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("#", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    manifest_sha256 "1ee827ccd9341dbb856f457aab8b7e4779213380bb8cfa37f03c62dcc5a0c6a5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7611b387308f074f292950672ddf0afbcf0ca1a6419d1d8123ccd5f83595aa41"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6426007a4400f438d4a825e2659ac5d8e84c89d4aa8c516ebaf0db464a8b5681"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "658eaba311799968f84d7056c7006ac0230faf269d3654d94a634cad9ed3f0b7"
    sha256 cellar: :any,                 arm64_linux:       "c5570689974ba2edba571f9789a9efca83cc9eaa1061e2f724a3470c64395d6c"
    sha256 cellar: :any,                 x86_64_linux:      "2a1919b53baa9bfc6df21b58df9fd60d092c6e89e56788f594bc91ea2f2aeba5"
  end

  deny_network_access!

  def install
    makefile = if OS.mac?
      "Makefile.mac64"
    else
      ENV.cxx11
      "Makefile.linux64"
    end
    system "make", "-C", "emu", "-f", makefile
    bin.install "emu/picat"
    prefix.install "lib" => "pi_lib"
    doc.install Dir["doc/*"]
    pkgshare.install "exs"
  end

  test do
    output = shell_output("#{bin}/picat #{pkgshare}/exs/euler/p1.pi").chomp
    assert_equal "Sum of all the multiples of 3 or 5 below 1000 is 233168", output
  end
end
