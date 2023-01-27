class Metview < Formula
  desc "Meteorological workstation software"
  homepage "https://metview.readthedocs.io/en/latest/"
  url "https://confluence.ecmwf.int/download/attachments/51731119/MetviewBundle-2023.1.0-Source.tar.gz"
  version "5.18.0"
  sha256 "8d013c5f025bcf270e8bd3786e2b0712439d0830b04a4bcc8e6668d1374418c5"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "dc93147da9af9069045b3e80ec7c76da0ebfd9e4645923673ffce74ea50d9b55"
    sha256 arm64_monterey: "39f6890d9e40a4351cf23e9a56731eb3b32ea298d27ee4b21feac91a05bb922d"
    sha256 arm64_big_sur:  "4492b4b47ceff67a110009956916a1feb211e3b3b904f1d3d024c670c88056f1"
    sha256 ventura:        "43a91f57e97f8eb16a72ec73d369d9da4b87621bf673b43afa4a71f428d588ca"
    sha256 monterey:       "9c23d17e7fe38121d1b5a9cc97585f8c81f3a88b964689b9ff0b48a231419c76"
    sha256 big_sur:        "c93c9ee267110baa1ff9281d958f8645bc08634669eed54d1b8783b568006590"
    sha256 x86_64_linux:   "0a66916e0bb582832838f39c472dd2656573954a54152b655e6da5f2ea79fede"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
