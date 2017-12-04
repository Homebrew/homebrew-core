class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nco/nco-4.7.0.tar.gz"
  sha256 "5ba930f00a0e9775f85748d145acecfe142f917c180de538b2f8994788446cf8"
  revision 1

  bottle do
    cellar :any
    sha256 "024db8523af982e803a574a21a34815db43906123dd96ce75510af0f752b8fd8" => :high_sierra
    sha256 "e92464c812022beb37ec3da70ea695162e8d8bdf0c35a3499ab7e1969566c4e6" => :sierra
    sha256 "c8251ca5372d933a1f1e14086d403838583722f546aae26850ad0ca4c9ac030a" => :el_capitan
  end

  head do
    url "https://github.com/czender/nco.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "antlr@2" # requires C++ interface in Antlr2
  depends_on "gsl"
  depends_on "netcdf"
  depends_on "texinfo"
  depends_on "udunits"

  resource("example_nc") do
    url "https://www.unidata.ucar.edu/software/netcdf/examples/WMI_Lear.nc"
    sha256 "e37527146376716ef335d01d68efc8d0142bdebf8d9d7f4e8cbe6f880807bdef"
  end

  def install
    system "./autogen.sh" if build.head?

    inreplace "configure" do |s|
      # The Antlr 2.x program installed by Homebrew is called antlr2
      s.gsub! "for ac_prog in runantlr antlr", "for ac_prog in runantlr antlr2"
    end

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
