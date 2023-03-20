class Metview < Formula
  desc "Meteorological workstation software"
  homepage "https://metview.readthedocs.io/en/latest/"
  url "https://confluence.ecmwf.int/download/attachments/51731119/MetviewBundle-2023.1.0-Source.tar.gz"
  version "5.18.0"
  sha256 "8d013c5f025bcf270e8bd3786e2b0712439d0830b04a4bcc8e6668d1374418c5"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "e633a73b067cc58c9ac861a5c383f2d86b3e74c1a92c3aa0462e1bd9d0a3a245"
    sha256 arm64_monterey: "38f65b479493f57786622fe63989d6b8a91a20f6be9e6bd1f316f6b3b6ad9b4c"
    sha256 arm64_big_sur:  "08c16cda4c72cdf1d5ea1bd917131a4689c8b3a908b6035d344b71e004675538"
    sha256 ventura:        "9bbc9c4a8bc3f9c6dcab82201b9fd27d57ebd78d0ac36e9e247724b6b0c70ab3"
    sha256 monterey:       "48561176bcce67aeff1ae4a09e80b6ea5a16e9c46eee0d57fc56e5856f705062"
    sha256 big_sur:        "e28284af977920c4335534fbff697aadaf3fb0b623cc10462db190e04fef28df"
    sha256 x86_64_linux:   "63935765900475b8f8775c7e62c7149daded26711241a9b42b1a794da19f7760"
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
