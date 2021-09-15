class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/5.0.1.tar.gz"
  sha256 "37d11ffe582aa0ee89f77a7b9a176b41e41900e9ab709e780ec0caf52ad60c4b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d858bb5c6d99b2218f859aa09c9e472ba2970d0f3a705f546832454f9cc6c8c1"
    sha256 cellar: :any, big_sur:       "9f5fe0a1ac870adc44b85ed96f5f5c3f3d215bb8fc90c04dd337cc651f08052a"
    sha256 cellar: :any, catalina:      "2caed3ab29749404d1dfda25d4326e9b9167e800e43ebae0849e483c4fe7c889"
    sha256 cellar: :any, mojave:        "a81c6407c5d63ecd545a3f02aff99ee99299767a5b69a377fe8971841b1fc0d5"
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
