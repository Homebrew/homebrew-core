class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/4.8.1.tar.gz"
  sha256 "ddae3fed46c266798ed1176d6a70b36376d2d320fa933c716a623172d1e13c68"

  bottle do
    cellar :any
    sha256 "8a031331ccf4203570d7e87acc7da5434820dd872ce7c6690d02094b20cfa67f" => :mojave
    sha256 "29a8dcb249967c2ab554b43a0ef22e426162d19fd3c54a2d74ae57ca290dc38c" => :high_sierra
    sha256 "3a0e9165d9da9e265d86dbf38669a6c88e7adef3993cc1e0909769a59450493a" => :sierra
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
