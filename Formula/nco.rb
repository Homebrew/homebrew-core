class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nco/nco-4.7.5.tar.gz"
  sha256 "36f2132482a2eb9910ff9f760f0e61168aee874ad473a187cd8e5f7db2d2e617"

  bottle do
    cellar :any
    sha256 "8ddb5fa7d3c0f80d439a943ad32c03ca7c9670dfee40027bf3659edbdd66962c" => :high_sierra
    sha256 "102fab981b2a047cbafb4cba167e7fd4b7e1aa1b4a7842096a28ce0a381da952" => :sierra
    sha256 "c077d9e0d05c25b41a853524c04f701c48045f9d4645cbed612cb3669bca0b47" => :el_capitan
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
