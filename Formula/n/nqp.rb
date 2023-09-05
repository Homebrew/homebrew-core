class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2023.08/nqp-2023.08.tar.gz"
  sha256 "a0774ffa60b2d0f12f52ac433501ba4d5d4fafec8b3cf2baab8e0ac817455a25"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "82aae859724117afd8e6be746dcc7449bc64cd53fffc4d3f218b5527ef1ca980"
    sha256 arm64_monterey: "47aeabbdf3201581bca69f907b2fd397faaaa9c2ae56d1bf9f0e61dea166529e"
    sha256 arm64_big_sur:  "4e1bfb41ab5922c807f8a00a94579e1ff7adf182d050c7122492ce3d36f4c2d1"
    sha256 ventura:        "ac4dad648ed5828cf7554ad0426b3f1c841e1045a8914ba3be894b0f3039904f"
    sha256 monterey:       "6cc7300b754264d0ab541a1b86d2527e122ab6850b2656d0e24c8aae094d49a5"
    sha256 big_sur:        "b3637dcf4a469379091620ec02f53de463881c5ac15d41a8e32bbc65cafd261e"
    sha256 x86_64_linux:   "28d3d5b50a707c764dbf8efb8295598026a95e822408cf6fc919e8f3bf46ce70"
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
