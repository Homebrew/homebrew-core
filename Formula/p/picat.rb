class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "https://picat-lang.org/"
  url "https://picat-lang.org/download/picat39_src.tar.gz"
  version "3.9"
  sha256 "02e7ae7d7efa9e7fd58b5fb4c1218afb331710f0c6301e46ebc5f670af347331"
  license "MPL-2.0"

  livecheck do
    url "https://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2a9beaab92eecd166bd9d526e159d327d621f0fd6b6ff33b20918fb94feb571"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b504f1331d85fc37964a0562e0c54386993275d89a915c1f550baaf995b2c32a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8eebc88a6342e2b01ce5c896e175356780b44cbfa0f4ec27333cd7bbd9ddc9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9532dcfa7a7a997a4e011d6a7ae3970884fe5a4bd9aab21f898c5cd0330a0905"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e69a8477a5c33a3aa90759f9ec851a9f5f1b45cc72be52e514b031d8b8c530ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "446bb07d6962c52b3249ef7fdfd0deaa69645b3f1c5d7e86618e19b68cfaa206"
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
