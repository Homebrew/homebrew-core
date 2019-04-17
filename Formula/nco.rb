class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/4.7.9.tar.gz"
  sha256 "048f6298bceb40913c3ae433f875dea1e9129b1c86019128e7271d08f274a879"

  bottle do
    cellar :any
    sha256 "96aded8565536d465a5fac6d90b94f71dade2b871a8af39f71ecf4260230ed60" => :mojave
    sha256 "94ef7f7a7cb031c2743303e8d9605c25d858350619760e3416544b6d04af4464" => :high_sierra
    sha256 "d0fbb588f021ccfcdf46c2cd50f81a91ab9702ebdf5caab42f97f67393c67e29" => :sierra
  end

  head do
    url "https://github.com/nco/nco.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "antlr@2" # requires C++ interface in Antlr2
  depends_on "gsl"
  depends_on "netcdf"
  depends_on "texinfo"
  depends_on "udunits"

  resource "example_nc" do
    url "https://www.unidata.ucar.edu/software/netcdf/examples/WMI_Lear.nc"
    sha256 "e37527146376716ef335d01d68efc8d0142bdebf8d9d7f4e8cbe6f880807bdef"
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-netcdf4"
    system "make", "install"
  end

  test do
    testpath.install resource("example_nc")
    output = shell_output("#{bin}/ncks --json -M WMI_Lear.nc")
    assert_match "\"time\": 180", output
  end
end
