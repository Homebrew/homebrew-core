class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2025.06/nqp-2025.06.tar.gz"
  sha256 "cfb396d6d0114d00f0dc2de4cf5f424fa72968e53c9c7cb75690bcdfd45bfcc5"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "314cda261f3731d39b2dbd3b2c3a8c3fd20174ec08c3df1f2fbba50bfc29e10c"
    sha256 arm64_sonoma:  "169056e41d207dc7a654c05f00f3b1d660405fa3478aa9e1a9b0fa5186ad5339"
    sha256 arm64_ventura: "edc3a0cfeb895b4788039aa4b13490ca848c85e38a6d6c4bd2a22bd8dbf1c6b7"
    sha256 sonoma:        "7dbef48daaee380f83a82c33b5df9b48aeca9b5d3d114dafc8a13619063e4e04"
    sha256 ventura:       "e59ff2f9cfdabcdfff4b7a1d938a6b01a20b6eb41b743ee5d14008a64e8ebcb2"
    sha256 arm64_linux:   "8d90f9b065b53f99470b196bc321e3d3df76ab0e6bbf3b893fe2a83c29535a54"
    sha256 x86_64_linux:  "0076a6be82ff837cf5d21177c8a68d406b565ede8352e71033c27f9750e596eb"
  end

  depends_on "moarvm"

  uses_from_macos "perl" => :build

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    ENV.deparallelize

    # Work around Homebrew's directory structure and help find moarvm libraries
    inreplace "tools/build/gen-version.pl", "$libdir, 'MAST'", "'#{Formula["moarvm"].opt_share}/nqp/lib/MAST'"

    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}/moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end
