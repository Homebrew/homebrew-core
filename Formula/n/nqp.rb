class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2025.11/nqp-2025.11.tar.gz"
  sha256 "bcd772c39d6446d771260897c5450c559f9ef07539d1c4e622035549e85e832a"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1a90ad7d0a68af6ef491d22ad07fe107ad53fc4294d44b33c2c6092e3878a031"
    sha256 arm64_sequoia: "a22fc99ac160793f1099c37345c03ccac82d348d717637a01b39d6da1c0a7ca8"
    sha256 arm64_sonoma:  "bdd184a80f1cb619d87c8022a32f03c0e9304c1ed98172a25b33b323617c07b1"
    sha256 sonoma:        "fd8a167075d519a0e487e1979f569fbe5ad86cc46e7cf8513374359698d8174a"
    sha256 arm64_linux:   "42003a84b4b6756e71b33598d83953301d378edf3f0e2fd296a2d2c11854b858"
    sha256 x86_64_linux:  "402955e963cb2be7706545cb83b62458613366f0c431e48bea884e24d9678176"
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
