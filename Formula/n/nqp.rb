class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2024.07/nqp-2024.07.tar.gz"
  sha256 "ab13f2de962817bfedc971088aa6b54911c424150dc284623444ef64878af07e"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "105257f44f70978ebe9fcf1c33eac8bc5ee72d26773b2312678cbd3711aea13e"
    sha256 arm64_ventura:  "842bb2930db5ba422f859f725a0bb5c950d48d5e056ad173f2361f209e755d93"
    sha256 arm64_monterey: "df5e67efeda4d2f2c252c1ca1ec7923b0e2d8a13b60b7ca661bdb19548d4a2f1"
    sha256 sonoma:         "27a91553fc5e2e5a42d9b9ee297d9f17d06cd06169a2a095f33a3625ab3a9d59"
    sha256 ventura:        "b65c891afa054027a15ef68d824c25ed7accb2e7fe94b3fbc7ca9bc215517d07"
    sha256 monterey:       "b73588c76b605da84d322d9e5510c2d4f77953054689bbf250304b826db980a0"
    sha256 x86_64_linux:   "2e6c831e840920211964963b2a15e8a9e566900b7e37f20da5640cef7ba57ed1"
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
