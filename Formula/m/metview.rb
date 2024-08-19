class Metview < Formula
  desc "Meteorological workstation software"
  homepage "https://metview.readthedocs.io/en/latest/"
  url "https://confluence.ecmwf.int/download/attachments/51731119/MetviewBundle-2024.4.0-Source.tar.gz"
  version "5.22.0"
  sha256 "ec8b04db35968d1851c32c2600fc44928abcfc3b8a3d5e052d101e88530e23dc"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/METV/The+Metview+Source+Bundle"
    regex(%r{>\s*Metview\s*<.+?<td[^>]*?>\s*v?(\d+(?:\.\d+)+)\s*</td}im)
  end

  bottle do
    sha256 arm64_sonoma:   "acb23385168d8ae5e8562486c43810bbb171d298e6865a99455c1c5beacaacb8"
    sha256 arm64_ventura:  "6c1e59523ecf1721d44188cd539af4a4fa7c391cd8d11322f37d118cd3f3491a"
    sha256 arm64_monterey: "ebf98c1043aeec1bee93777fb2fd40006703e796cfa4d504c26e50b76c0f4330"
    sha256 sonoma:         "33af8f64bbddbcf56d93ef0462d4ccfdcf464a6d1c28dd36a8d793efaf1d3f09"
    sha256 ventura:        "93a4110779ba74ef222d9ce6f257a6a23734fe9ac7c2ae9817b63774992a64e4"
    sha256 monterey:       "0a79a846f34ff65fa956aa22ddb022ab789bd9fd730f5da5216818bf807eb345"
    sha256 x86_64_linux:   "4f445d199a4e2ddec19008d389dc535653db51d33d6e1e95bdf5aeb72045b325"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "eccodes"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "gdbm"
  depends_on "glib"
  depends_on "libaec"
  depends_on "libpng"
  depends_on "lz4"
  depends_on "netcdf"
  depends_on "openssl@3"
  depends_on "pango"
  depends_on "proj"
  depends_on "qt"

  uses_from_macos "bison" => :build
  uses_from_macos "flex"  => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "expat"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "libtirpc"
    depends_on "openblas"
    depends_on "snappy"
  end

  def install
    args = %W[
      -DBUNDLE_SKIP_ECCODES=1
      -DENABLE_MIR_DOWNLOAD_MASKS=OFF
      -DENABLE_BUILD_TOOLS=OFF
      -DENABLE_ECKIT_CMD=OFF
      -DFFTW_PATH=#{Formula["fftw"].opt_prefix}
    ]

    if OS.linux?
      args += [
        "-DRPC_PATH=#{Formula["libtirpc"].opt_prefix}",
        "-DRPC_INCLUDE_DIR=#{Formula["libtirpc"].opt_include}/tirpc",
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
    system bin/"metview", "-nocreatehome", "-b", "test_binary_run_grib_plot.mv"
    assert_predicate testpath/"test.1.png", :exist?
  end
end
