class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat355_src.tar.gz"
  version "3.5.5"
  sha256 "8e13264dc582e51332fc664c11371a3567c41b7a43489c615edf0e8243006be5"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "706a80ca0b0a8a9b03c097f49299e08b64a95df2136fbd6865cfd1ebb9c91e9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1acb9788adc397f8f0aa3574572d3c2eb20c73afadda55fdf0cb9fdcc5444089"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb6f6092f0f19458337fef230ac6e9027d2c9900261d8064524b8215a9e1fcb0"
    sha256 cellar: :any_skip_relocation, ventura:        "ef4ef5ffdf98bb526c6a094b97d90d334c9b2a7979c5704ab205c8b79d9e6151"
    sha256 cellar: :any_skip_relocation, monterey:       "22476f09607342d6fc188a7a2af52abb8f9a07dea617f9b20f687cbe8b64000e"
    sha256 cellar: :any_skip_relocation, big_sur:        "24443b0f0f8bd6b73ab32b8eaec631b5387f11edea5036b0cd3972a40fa292b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "840fac1dacd2ae05a0a57cf28361b0554f48f018a6d2503df586ff75822051c0"
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
