class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2023.05/nqp-2023.05.tar.gz"
  sha256 "1402db7e3ca6f2f3dfc1e98aa32e0e2a937e49b2a777a74c62268a98abb3bbd2"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "42161ceb0ce493c8518d679935fe3ca70a29867374ae1aca1b08fc26c6eb3964"
    sha256 arm64_monterey: "0f573adc242453df87c1f3735b369f6fd34b46d9c52964243ac1df9e1c2ba05b"
    sha256 arm64_big_sur:  "f0589a1eb81303b423b3b3f7ed08b4a85fb0bc5705787eea45ef19b9a4955b8f"
    sha256 ventura:        "70ed64422c18af15f46269f2e9e203cb54b994724e65ea122acfd444896ea1cb"
    sha256 monterey:       "8df90c6aede46d8877fb1e13582ce086114059ca3360a4ec93ae4c0992d2adb3"
    sha256 big_sur:        "352aa6651253ef58286f5e38aeb80ea3aa3171aa762a710db1fd2cec776c060f"
    sha256 x86_64_linux:   "f0cc29632d6b302aa3ff4ac5ae96ac688bd1d86f6c679cf88e62576f454633c9"
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
