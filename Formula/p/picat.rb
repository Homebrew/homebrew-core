class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "https://picat-lang.org/"
  url "https://picat-lang.org/download/picat399_src.tar.gz"
  version "3.9.9"
  sha256 "d560011b88728777221000d9952c06ec2abab6fda5d7748817d52e74352f2a69"
  license "MPL-2.0"

  livecheck do
    url "https://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a98e89c74da5992c6d5bdb5112220aa011c7e689d3969fd10bef693aa72dfb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44402256892b2250e7285d48b4986debc69e74ea945b362b7581c97dbfd99156"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "176489910fc716b0bfc4e140c68c719ceb398e0b975c7de5002451b3f53f6b85"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cbf65e6651968a83c3eadb6ac00397d2da481ad971b43db23e02723acf62a6e"
    sha256 cellar: :any,                 arm64_linux:   "3b5b8809f91f5912123c85f552b713d36b1d37d07f90631423cd7fa1002d0f0f"
    sha256 cellar: :any,                 x86_64_linux:  "b9da709d0a7e5aefd904620024a9fa56c4d26fc68b53d53ba01af3a200d8b768"
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
