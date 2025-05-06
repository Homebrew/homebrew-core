class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "https://picat-lang.org/"
  url "https://picat-lang.org/download/picat38_src.tar.gz"
  version "3.8"
  sha256 "c238a474f345a1b339acbd00d5fc332bd908e9822b9bd89fb855d2c8a7a10e72"
  license "MPL-2.0"

  livecheck do
    url "https://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8baa72e2d29b850efa2c9f048041e4efbf1264b303d2f87907f21ba702022255"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec6711ce15529f9918b690ac2a897f375768f9b1188212449ef5a10b52305820"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da90a0ec7a0b2d745e06880c27e9851004140559b83e2e62adccee92b5b1eb62"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e7142a99b62517ab3ec4ef69bc87b0f2a2495679bb96071e8bde0f4032b26f7"
    sha256 cellar: :any_skip_relocation, ventura:       "f32341afb685b5a5a1c34bea930101e949c03a414ffaa3fb8dfc197228c0b262"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db5c79f8eb48c3e0e107f5b9f7b40786d5827b030432db5c0635af347956caac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a1a72ffb232b2ac33a9eb001751a63ddee735c248cdf55c43cb0482be26391d"
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
