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
    rebuild 1
    sha256                               arm64_tahoe:   "8ea0aac6d5efa12195864cd47b2a6c3f2947fb67c08dcd20484776aabc6ee1c8"
    sha256                               arm64_sequoia: "8d3b1a19af31c9bd7e1c2bc0e9ee7d973531072b8a21809bf33c3f1fc1af19f2"
    sha256                               arm64_sonoma:  "3c7f68f83c3a04ccf87213a3c2e658c5c1d8d3042e0bc938a6fc79c4822bceb5"
    sha256 cellar: :any,                 sonoma:        "9967ae04346f24e99ef21b3f8cb173b2bd60adc0282f0f148bff79b7917d6923"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7924342f589a4aa78003c16731d9a13dfdf2ce19cc2c666f214083a263c667fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81dbd92e9ed28d630b33df5e19c966dde006ce193601edb94713d1a8c7d4636c"
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
    depends_on "gcc"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "libtirpc"
    depends_on "openblas"
  end

  def install
    args = %W[
      -DENABLE_MIR_DOWNLOAD_MASKS=OFF
      -DENABLE_BUILD_TOOLS=OFF
      -DENABLE_ECKIT_CMD=OFF
      -DENABLE_TESTS=OFF
      -DFFTW_PATH=#{Formula["fftw"].opt_prefix}
    ]

    if OS.linux?
      args += %W[
        -DENABLE_CLANG_TIDY=OFF
        -DRPC_PATH=#{Formula["libtirpc"].opt_prefix}
        -DRPC_INCLUDE_DIR=#{Formula["libtirpc"].opt_include}/tirpc
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
