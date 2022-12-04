class Metview < Formula
  desc "Meteorological workstation software"
  homepage "https://metview.readthedocs.io/en/latest/"
  url "https://confluence.ecmwf.int/download/attachments/51731119/MetviewBundle-2022.8.4-Source.tar.gz"
  version "5.17.4"
  sha256 "8150a9a4ae47bfc7c99ce30bcaf8f75392772f30b5abef33a320dfd24c04ba71"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "2344adb27c00fd086c3955b6315e1911ae42955e2f06bc5c7ceb7875775877c2"
    sha256 arm64_monterey: "3677958feeac1339f0d7c0686a6df3e460ddcd0b8a351b54e93d33358568db09"
    sha256 arm64_big_sur:  "070adc24a43cb86f6c50fd1131f5b6580f0bcdd6bc25f4ff8dcea93f123a8bdb"
    sha256 ventura:        "623f0cb819c209cfa35880df2b17425ccf491c22890637abfa53d29fe47f8cd2"
    sha256 monterey:       "c45814f3848ac335a37e4d3f1cc21d00407e04945ecc8ad815f309eb1ce591f5"
    sha256 big_sur:        "f622ea0f7fd6cc5984399b58d8a80d434f91aeb2ea4c45bab2b730aec645d135"
    sha256 catalina:       "a48faecade4a7feb1da6e2b6b76b8151318a2cc34077967abcebe64272910fbb"
    sha256 x86_64_linux:   "1e4793c46e346be50c539edfee0934dc750dc278779a781e10c401f59013f1e6"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "eccodes"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "gdbm"
  depends_on "netcdf"
  depends_on "pango"
  depends_on "proj"
  depends_on "qt"

  uses_from_macos "bison" => :build
  uses_from_macos "flex"  => :build

  on_linux do
    depends_on "libtirpc"
  end

  def install
    ENV["RPC_PATH"] = HOMEBREW_PREFIX
    cmake_rpc_flags = if OS.linux?
      "-DCMAKE_CXX_FLAGS=-I#{HOMEBREW_PREFIX}/include/tirpc"
    else
      ""
    end

    args = %w[
      -DBUNDLE_SKIP_ECCODES=1
      -DENABLE_MIR_DOWNLOAD_MASKS=OFF
      -DENABLE_BUILD_TOOLS=OFF
      -DENABLE_ECKIT_CMD=OFF
      -DFFTW_PATH=#{HOMEBREW_PREFIX}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *cmake_rpc_flags, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Avoid references to Homebrew shims directory
    # (ecbuild stores some references to the build directory - not used, so we can remove them)
    rm lib/"metview-bundle/bin/metview_bin/compile"
    rm_r lib/"metview-bundle/lib/pkgconfig"
    rm_r lib/"metview-bundle/include"
  end

  test do
    # test that the built-in programming language can print a string
    (testpath/"test_binary_run_hello.mv").write <<~EOS
      print("Hello world")
    EOS
    binary_output = shell_output("#{bin}/metview -nocreatehome -b test_binary_run_hello.mv")
    assert_match "Hello world", binary_output

    # test that the built-in programming language can compute a number
    (testpath/"test_binary_run_maths.mv").write <<~EOS
      print(6*7)
    EOS
    binary_output = shell_output("#{bin}/metview -nocreatehome -b test_binary_run_maths.mv")
    assert_match "42", binary_output

    # test that Metview is linked properly with eccodes and magics and can produce a plot from GRIB data
    (testpath/"test_binary_run_grib_plot.mv").write <<~EOS
      gpt = create_geo(latitudes:|5, 10, 15|, longitudes:|30, 40, 35|, values: |5, 1, 3|)
      grib = geo_to_grib(geopoints: gpt, grid: [5,5])
      grid_shading = mcont(
        contour_shade                  : "on",
        contour_shade_technique        : "grid_shading")
      setoutput(png_output(output_name:"test"))
      plot(grib, grid_shading)
    EOS
    system "#{bin}/metview", "-nocreatehome", "-b", "test_binary_run_grib_plot.mv"
    assert_predicate testpath/"test.1.png", :exist?
  end
end
