class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/4.9.3.tar.gz"
  sha256 "eade5b79f3814b11ae3f52c34159567e76a73f05f0ab141eccaac68f0ca94aee"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "d5e36895012c95cd251850c78603e44e8abc31cc7f728046fbf49a3e29d6aac9" => :catalina
    sha256 "dbb85ca7a1fce56f687bded4da9a1cf22dc9a2e2f9cd3e13c80711f86c1b416d" => :mojave
    sha256 "e7a71fa592453f83a04c696e4314347199a233109a2b6b0a95f3697f25ae192c" => :high_sierra
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
