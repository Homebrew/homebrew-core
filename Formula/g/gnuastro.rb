class Gnuastro < Formula
  desc "Astronomical data manipulation and analysis utilities and libraries"
  homepage "https://www.gnu.org/software/gnuastro/"
  url "https://ftpmirror.gnu.org/gnuastro/gnuastro-0.24.tar.gz"
  sha256 "c4e6401eee5d81619b82d8d18a6447851b36e0754118ebf5bdfac7a03194f981"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "cd892c14cabdaac80ba71e110b465b62700c68edd28c6d78da3386def97ce9fd"
    sha256 arm64_sequoia: "4cfd2845728a7f08a5d39f6894a68b3fc8b7b8e2b728d8172662fd4e98dd5241"
    sha256 arm64_sonoma:  "b2054ac5b01de48d6d055bc6c57d7fab1aa7d23ff944c94e0592d5868881f4be"
    sha256 sonoma:        "bee9d1dcefbc85b4bb16420fb094c0d46cb8d8e7cbdf07faa1f6aa03075153e5"
    sha256 arm64_linux:   "11deea38b1051ea1ae5f3f3d70f3502dea5f83a2e2e82877d047ab4eba0f5d9c"
    sha256 x86_64_linux:  "2e45da2c46731e0708fafa0b9a0eeab7caf5e59fe9ab68478a7e2bc2f190a373"
  end

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "gsl"
  depends_on "wcslib"

  def install
    args = %W[
      --with-gsl=#{Formula["gsl"].opt_prefix}
      --with-cfitsio=#{Formula["cfitsio"].opt_prefix}
      --with-wcslib=#{Formula["wcslib"].opt_prefix}
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asttable --version")
    system bin/"astarithmetic", "10", "10", "2", "makenew", "3", "constant", "int8", "-oint-1.fits"
    system bin/"astarithmetic", "10", "10", "2", "makenew", "7", "constant", "int8", "-oint-2.fits"
    system bin/"astarithmetic", "int-1.fits", "-h1", "int-2.fits", "-h1", "+", "--output=addition.fits"
    assert_path_exists testpath/"int-1.fits"
    assert_path_exists testpath/"int-2.fits"
    assert_path_exists testpath/"addition.fits"
    assert_equal "1", shell_output("#{bin}/astfits addition.fits --hasimagehdu").strip
    naxis, naxis1, naxis2 = shell_output("#{bin}/astfits addition.fits -h1 --keyvalue=NAXIS,NAXIS1,NAXIS2 -q").split
    assert_equal "2",  naxis
    assert_equal "10", naxis1
    assert_equal "10", naxis2
    min, max = shell_output("#{bin}/aststatistics addition.fits -h1 --minimum --maximum -q").split.map(&:to_f)
    assert_equal 10.0, min
    assert_equal 10.0, max
  end
end
