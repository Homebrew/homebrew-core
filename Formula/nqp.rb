class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2023.02/nqp-2023.02.tar.gz"
  sha256 "e35ed5ed94ec32a6d730ee815bf85c5fcf88a867fac6566368c1ad49fe63b53f"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "fc253a0bb1d29a93857dfe3d402dba22cbddcab0be8a8e5541f6108bf4c27ffc"
    sha256 arm64_monterey: "3169539f5010d2cbc10c89e22945413d0a33debf8456e718ca94af3fa4621480"
    sha256 arm64_big_sur:  "8fa46cdc9fb4330fa5b7b1da8f7cacaf84d35454c94b5d132d0dd8f65f1e2c3a"
    sha256 ventura:        "2f7199a8d0fe237917764462e5090084bbf68fc8a58162e441f207cda5e64914"
    sha256 monterey:       "2e701459c33f736b8315e946ec502e56b39ec5921e4729755b97732bc82627f1"
    sha256 big_sur:        "5f35728910fd8a20a5032bcaee7fe99773c323a203b8dfd4c2e242d7e12e636d"
    sha256 x86_64_linux:   "328a960f79a15ca93fd1fc9e0ac0630db5772bc786ee3a4674ee980caf53a634"
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
