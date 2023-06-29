class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2023.06/nqp-2023.06.tar.gz"
  sha256 "ddcb92f29180699ebaf0a7faa46ad4ac902f9c8826d7476d9c6f71176cadd7d3"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "6de4c501b2f9d51c26743c5e8dc277cb1d3be1bf833fd2d8edb626c7dc8b7043"
    sha256 arm64_monterey: "4718040cae7912e40176beedddb95e865f30e979e57d08796ee1299330eb7b99"
    sha256 arm64_big_sur:  "083187e3b032bfbf440f79586a3cc56ee13660acef3c974dfdbe7c597a0cd0ef"
    sha256 ventura:        "474ef34e4698ef872bf33a095829f77b3ce77d032bfca3c34c531313ee79e62d"
    sha256 monterey:       "4ce6f856be4697992bee7688dfebe10a74fcb6e68d3dcc6db9e611735694f71b"
    sha256 big_sur:        "c7940d2f4c989cecf2dca1a366582821fbd253c8c60ea3788602edaa90e810cc"
    sha256 x86_64_linux:   "0bf1a53bd5bc89d14cd2c9f8a4841c102bbdb3c2a6d5f21e87ba6d8396a8bbd8"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "moarvm"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

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
