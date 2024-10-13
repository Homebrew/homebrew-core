class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2024.09/nqp-2024.09.tar.gz"
  sha256 "03de709b6353c4cc80aeb8ba2ef3fe54ec4bfe04ea6a10c631ca560b58cb181d"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "19f6ff9e6ee7caf200e224a09910706310d8692be62b1300da783ec2e24996ed"
    sha256 arm64_sonoma:  "abd3a568acf24cf34839add6f70ff9a63c644a5bc7acf423b161ee851acb2c5c"
    sha256 arm64_ventura: "889ba7306744be3d4e976098e16ece5ca9dbbf55150d48e930325efce3e9f32e"
    sha256 sonoma:        "8da32de0a209b358e7ea6b6c478dd7ce34bcb3a0e0b1b25d73d4398014d27cb9"
    sha256 ventura:       "09d06399e43ac57ecffe03a9aa0d4dc81d3707c2481ce43230cc3c8a804cdae6"
    sha256 x86_64_linux:  "9972bfd1016fcf35afe5a0efbdfee9cdc47ecadb0cc9b395304d491a6fd4c740"
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
