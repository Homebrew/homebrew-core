class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2022.04/nqp-2022.04.tar.gz"
  sha256 "556d458e25d3c0464af9f04ea3e92bbde10046066b329188a88663943bd4e79c"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_monterey: "96bf32b98852990200a2c1af4bd599089bffaa4b3eee61f9dd00644343f844ee"
    sha256 arm64_big_sur:  "0785544010d6d154145f2f01c88e7016ecdcb2e79298ff6f0f2ed8f796d02429"
    sha256 monterey:       "ac4a36b97a26107ba0170048e8a689a68db643a185d84b455f88fe91464e0204"
    sha256 big_sur:        "39b6baf2607cdb1843f1419786dcb8a2940498e351a5990330dfea2d96cfce62"
    sha256 catalina:       "59f28fef93a815c2fa15be4b3c448886a2bd9cc59fcae8c58fcdb554fc8e3d07"
    sha256 x86_64_linux:   "36ff4fcc84b071b261501dea0500acf9539cf631d4b6ffa2e5bb7dbdebf400e5"
  end

  depends_on "libtommath"
  depends_on "moarvm"

  uses_from_macos "perl" => :build

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
