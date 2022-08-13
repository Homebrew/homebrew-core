class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2022.07/nqp-2022.07.tar.gz"
  sha256 "58081c106d672a5406018fd69912c8d485fd12bf225951325c50c929a8232268"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "f594a0a65bb4335864a011a9e184e7c35ece4a7441ffdb7d576bb9406699503e"
    sha256 arm64_big_sur:  "cb61da491155f138a9847a34cc84c6abe717050cdc0143908c58e73b7028f98e"
    sha256 monterey:       "6b9b73cc13a7d53b006af8445cffa6a379671b2ae4fddfc94fe7c8197c967958"
    sha256 big_sur:        "b8705e7496a17ebca1f805f1cde66490195a13ca6c3fb25a3f3306b1e86da1d8"
    sha256 catalina:       "c46961f64c53996d4701db8a72e29966e0353312371422f35227bef83efa7630"
    sha256 x86_64_linux:   "9c33f17ee8f23aeddc0c76b4e111551f80a89aa311a1c3e36539cf561ae72069"
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
