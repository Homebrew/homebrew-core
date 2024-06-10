class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2024.05/nqp-2024.05.tar.gz"
  sha256 "74304a2781bb681ec0be97a45a9d4002e263ec00cc624f0350b217b6c0abbe82"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ce81f15f1501c24e83329e73e27e229b5be5005f70f4a43bb5be3c99a1b8851c"
    sha256 arm64_ventura:  "4af43a122613637546c1b4eece532e06f38e0ee5158053ee5b9609763999dc2c"
    sha256 arm64_monterey: "855105f3fc669fd53b18e8e2c20e174135c4043c7c220ef4baa66931d91dd061"
    sha256 sonoma:         "890cb534e20af34dd3ecc5b09559b1ac912359b090ce2f4965c122d3de3e34af"
    sha256 ventura:        "e02e8e2f350acc7add3d0995ab4b7ac48bb799420883e8fac23c42804e8415f8"
    sha256 monterey:       "37e9e3e19859ad018ae463747109b82b93796ed797980d5ad515dfbfed7ecc18"
    sha256 x86_64_linux:   "fa71acb99c0f1ec343a5b386f8c21117103abf19affd04ca8a92b654a62d090f"
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
