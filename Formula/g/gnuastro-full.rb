class GnuastroFull < Formula
  desc "Astronomical data manipulation and analysis utilities and libraries"
  homepage "https://www.gnu.org/software/gnuastro/"
  url "https://ftpmirror.gnu.org/gnuastro/gnuastro-0.24.tar.gz"
  sha256 "c4e6401eee5d81619b82d8d18a6447851b36e0754118ebf5bdfac7a03194f981"
  license "GPL-3.0-or-later"

  keg_only "conflicts with gnuastro (both install ast* executables)"

  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "gsl"
  depends_on "jpeg-turbo"
  depends_on "libgit2"
  depends_on "libtiff"
  depends_on "libtool"
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

  def caveats
    <<~EOS
      Optional runtime helpers (used only by some commands/scripts): curl, ghostscript.
      Optional GUI viewers (casks): topcat, saoimageds9.
    EOS
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

    jpg_fits = testpath/"from-jpeg.fits"
    tiff_fits = testpath/"from-tiff.fits"
    system bin/"astconvertt", test_fixtures("test.jpg"), "--output=#{jpg_fits}"
    system bin/"astconvertt", test_fixtures("test.tiff"), "--hdu=0", "--output=#{tiff_fits}"
    assert_path_exists jpg_fits
    assert_path_exists tiff_fits
    assert_equal "1", shell_output("#{bin}/astfits #{jpg_fits} --hasimagehdu").strip
    assert_equal "1", shell_output("#{bin}/astfits #{tiff_fits} --hasimagehdu").strip
  end
end
