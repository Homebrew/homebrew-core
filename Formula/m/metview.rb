class Metview < Formula
  desc "Meteorological workstation software"
  homepage "https://metview.readthedocs.io/en/latest/"
  url "https://confluence.ecmwf.int/download/attachments/3964985/Metview-5.26.2-Source.tar.gz"
  sha256 "6245b34909ac697f941f92ee1293f14f96c31c3919f41db5dba706de6c9d43e3"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/METV/Releases"
    regex(/href=.*?Metview[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "5a1d1e76099dbf127a5b12d140c67177c89badf19738f851329a68e2fc907057"
    sha256 cellar: :any, arm64_tahoe:       "bd863ad07297b790be7f2926d5c0ece1ac0e6ac539a917df45bd2598a0505529"
    sha256 cellar: :any, arm64_sequoia:     "3faa35a75423cf43a8792429f3c37d6ad586573ad6993dd480e143eff9946874"
    sha256 cellar: :any, arm64_linux:       "4ca04059eda9ac1ba987a1735b48bbe4aacd240c5be43fb00d6bcbeb473513e7"
    sha256 cellar: :any, x86_64_linux:      "61d3356ddca4c0457bdac6122ee00357340c0adf7fe3bef276de6e92238caa34"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "eccodes"
  depends_on "eigen" => :no_linkage
  depends_on "fftw"
  depends_on "gdbm"
  depends_on "glib"
  depends_on "libaec"
  depends_on "lz4"
  depends_on "magics"
  depends_on "netcdf"
  depends_on "netcdf-cxx"
  depends_on "pango"
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "qtsvg"
  depends_on "snappy"

  uses_from_macos "bison" => :build
  uses_from_macos "flex"  => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_macos do
    depends_on "gcc" # for gfortran
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "libomp"
  end

  on_linux do
    depends_on "libtirpc"
    depends_on "openblas"
  end

  # FIXME: Should be handled upstream
  # MvTemplates.h:159:11: error: virtual function 'getInfo' has a different return type
  # ('char *') than the function it overrides (which has return type 'const char *')
  patch :DATA

  def install
    args = %W[
      -DENABLE_MIR_DOWNLOAD_MASKS=OFF
      -DENABLE_BUILD_TOOLS=OFF
      -DENABLE_ECKIT_CMD=OFF
      -DENABLE_TESTS=OFF
      -DFFTW_PATH=#{formula_opt_prefix("fftw")}
    ]

    if OS.linux?
      args += %W[
        -DENABLE_CLANG_TIDY=OFF
        -DRPC_PATH=#{formula_opt_prefix("libtirpc")}
        -DRPC_INCLUDE_DIR=#{formula_opt_include("libtirpc")}/tirpc
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
    assert_path_exists testpath/"test.1.png"
  end
end

__END__
diff --git a/metview/src/libMetview/MvTemplates.h b/metview/src/libMetview/MvTemplates.h
index 1bbb4cc..8296b57 100644
--- a/metview/src/libMetview/MvTemplates.h
+++ b/metview/src/libMetview/MvTemplates.h
@@ -156,7 +156,7 @@ protected:
     TMvFunction(MvTransaction* t) :
         MvFunction(t) {}
     MvTransaction* cloneSelf() { return new TMvFunction<T>(this); }
-    char* getInfo() { return Info; }
+    const char* getInfo() { return Info; }
 
 public:
     TMvFunction() :
