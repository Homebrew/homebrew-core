class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "https://cirrus.ucsd.edu/ncview/"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.8.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/ncview-2.1.8.tar.gz"
  sha256 "e8badc507b9b774801288d1c2d59eb79ab31b004df4858d0674ed0d87dfc91be"
  license "GPL-3.0-only"
  revision 4

  # The stable archive in the formula is fetched over FTP and the website for
  # the software hasn't been updated to list the latest release (it has been
  # years now). We're checking Debian for now because it's potentially better
  # than having no check at all.
  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/ncview/"
    regex(/href=.*?ncview[._-]v?(\d+(?:\.\d+)+)(?:\+ds)?\.orig\.t/i)
  end

  bottle do
    rebuild 1
    sha256 "62940cf53207de388e665e1d1376e48c684af71732422fff53c5ab660be55648" => :big_sur
    sha256 "0c7b273ab3f81d8dece1035fb0170542287492dad9573dd2c9bd4726b9ac82cb" => :arm64_big_sur
    sha256 "cd138ec52b70136fc6593d390a384490921b5cdfea173396e776f10f2fbc8466" => :catalina
    sha256 "17d275efffcb75749da6a8ad011fcc675e2db41b57fd1948e4a7951a1495aa08" => :mojave
  end

  depends_on "libice"
  depends_on "libpng"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxt"
  depends_on "netcdf"
  depends_on "udunits"

  def install
    # Bypass compiler check (which fails due to netcdf's nc-config being
    # confused by our clang shim)
    inreplace "configure",
      "if test x$CC_TEST_SAME != x$NETCDF_CC_TEST_SAME; then",
      "if false; then"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    man1.install "data/ncview.1"
  end

  test do
    assert_match "Ncview #{version}",
                 shell_output("DISPLAY= #{bin}/ncview -c 2>&1", 1)
  end
end
