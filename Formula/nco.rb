class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nco/nco-4.7.0.tar.gz"
  sha256 "5ba930f00a0e9775f85748d145acecfe142f917c180de538b2f8994788446cf8"

  bottle do
    cellar :any
    sha256 "9508029280a324f6341cfcbb36849531a19384b7cc7d9e292687f3f1f3b37c53" => :high_sierra
    sha256 "794c825d068f46f9144102ea83eaeb2064c3356eac33a5236c0e3613690c61eb" => :sierra
    sha256 "9b859c47c5aaac040731e9393a3b7d9caa43740b9eddd4ba4addc6aeba240b58" => :el_capitan
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
