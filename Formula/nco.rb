class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/4.8.1.tar.gz"
  sha256 "ddae3fed46c266798ed1176d6a70b36376d2d320fa933c716a623172d1e13c68"
  revision 1

  bottle do
    cellar :any
    sha256 "4dcdf9514a6379c2564a61a6b2784feeff47874ec950e4665193f333fd7efc2c" => :mojave
    sha256 "06cadac238310edc90e3a6f956af816a71734b65283e71e39a07169e4ea9b8bd" => :high_sierra
    sha256 "f93374f312d196f25eb550ef4c10645e4fc78f91a302c5afc23ea086b82ff38f" => :sierra
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
