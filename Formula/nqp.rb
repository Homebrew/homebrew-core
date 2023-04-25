class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2023.04/nqp-2023.04.tar.gz"
  sha256 "6735e5e601921cd427651e99bdf63be8338f4b815520803a97985dec488e50b5"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "0c7ee26b4170d9a4fa427421fde72b0fba604e3caac40eba458261eeb1eec82e"
    sha256 arm64_monterey: "f9377a83e0b82132c0a9a42052fbb14f3fdab8b66c02ca79fd15602dac175f9c"
    sha256 arm64_big_sur:  "82c795947d2f16cbe629fb15b78fead61cf2e1e73655dd22145623ec4b1e6b90"
    sha256 ventura:        "99cec83f3e6773cc8ffadc61596e43c8ff5be2578d059d31f6d7e1f94e866523"
    sha256 monterey:       "b543bc2a626acb0562fc424d7e605bb2e032de8dea60993c5cd6a1971a15d209"
    sha256 big_sur:        "b898642ec65388760f560c2e7dd05517ec68f55c3e161de40917d2f198e168f4"
    sha256 x86_64_linux:   "c470f995c5b629ef808903a5109f0e2161a85df8adfe3ac6797fa58427bb055b"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "moarvm"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
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
