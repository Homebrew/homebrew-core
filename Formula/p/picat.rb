class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "https://picat-lang.org/"
  url "https://picat-lang.org/download/picat39_12_src.tar.gz"
  version "3.9.12"
  sha256 "05322b324ee904a62ca5b892d99c0f3abcf3e8f2bad1ce64732c03d70ef5fadc"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c78f2020d268c556bf9ecf324b7ed75e230177aef48f02b4dc23abcc674a489"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "96e54aaf25f40b328f5b46086782d64006789a374a3b9d20fb909e4851bc1f45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bcf8820453e7a55a6dd0e0abed110cf3cd60e071c7e0599c7128afbf1f88ad6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "dda9e7c68bb84c5f1f25ab3e3467c1bd1e492d34423a5b69fbee7fc539b35508"
    sha256 cellar: :any,                 arm64_linux:       "f7af4ba06b779531cc0619e23988afb47302b8f2c79fa543ae6dd58911208aab"
    sha256 cellar: :any,                 x86_64_linux:      "d766512892f2c060ed297311fd7a0adc0f582ccaef1eb1cc9d98aa18a2200822"
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
