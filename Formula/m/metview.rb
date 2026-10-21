class Metview < Formula
  desc "Meteorological workstation software"
  homepage "https://metview.readthedocs.io/en/latest/"
  url "https://confluence.ecmwf.int/download/attachments/3964985/Metview-5.27.0-Source.tar.gz"
  sha256 "075a8c420c4850bd6695637470ef4a4638486a82d77092c65cc7921a30cdd5f0"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/METV/Releases"
    regex(/href=.*?Metview[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "55dea06ea5b4955dbb1487bf450a7582b5bd98b27bacefc4d63927253ce47a2b"
    sha256 cellar: :any, arm64_tahoe:       "4057fcde198282a5df807e72dfd9ebca94d5eed333ee52d56231b0bf9dc4cddb"
    sha256 cellar: :any, arm64_sequoia:     "2e41b93fda66bc5744d30db2fc8b0751513088f961be87d91bbf7602e9dd84bc"
    sha256 cellar: :any, arm64_linux:       "0efe4526e5cefdfad2c78d90601f8a13d5972a79e64106b0af64790fb3adce3b"
    sha256 cellar: :any, x86_64_linux:      "77a3da9cce7e0a31b7a3f68700f865d43469a31a8d835080f68796e105741ea3"
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
    depends_on "util-linux"
  end

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
