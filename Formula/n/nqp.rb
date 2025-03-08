class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2025.02/nqp-2025.02.tar.gz"
  sha256 "6cc4321cebecbe656e92b5ca0d245d50a5ecbda74ea28ca08c010c21a7d47dad"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "b95cd069fba45628cfa837bc68aefb57f0aad7aba79ba9c33894a7c97ef92d01"
    sha256 arm64_sonoma:  "d53567bc36efc660f4e733854a1b0d86766fdcad029ce49465aa07d48f9e6229"
    sha256 arm64_ventura: "5c1d35217418d6801fb48460acd08913ad07fa84e122cda0fc93c5e69c019bcc"
    sha256 sonoma:        "f2b83e8a115def1ceefceb55857cae05cc363b3b28b5d56a725b34ab81937f2e"
    sha256 ventura:       "fa28723b9bbaa5e50923c91f6faa93c971533bbbb296c8321b7c0ff44feb9c4c"
    sha256 x86_64_linux:  "446bfa450da4954dd195c1e80b66016dd8fff0b3081aff1c16444b4b1fd63138"
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
