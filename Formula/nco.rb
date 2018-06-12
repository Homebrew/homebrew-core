class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nco/nco-4.7.5.tar.gz"
  sha256 "36f2132482a2eb9910ff9f760f0e61168aee874ad473a187cd8e5f7db2d2e617"

  bottle do
    cellar :any
    sha256 "9c94fc2842a80233119a8ebe95542ae177abb4d2e0a2d84d55450e1b94ddd520" => :high_sierra
    sha256 "9903bcceaee345181bd47a8fbe4ee64d5ba19fbe55cc7582496e0358207ac70a" => :sierra
    sha256 "e7da312a30aab1ab41d82fb24ae59afd32bc4387e54334be434f6694fa085bea" => :el_capitan
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
