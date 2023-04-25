class Metview < Formula
  desc "Meteorological workstation software"
  homepage "https://metview.readthedocs.io/en/latest/"
  url "https://confluence.ecmwf.int/download/attachments/51731119/MetviewBundle-2023.4.0-Source.tar.gz"
  version "5.19.0"
  sha256 "13db916c98514d4ff236b24933dc86c6217c25dc6d493bbbe338f196c9ed817d"
  license "Apache-2.0"

  bottle do
    sha256 arm64_ventura:  "3697663e7d8e354263211814e500d34cafabb8ba9043c9fa4be4de853884f3dd"
    sha256 arm64_monterey: "86fbe6211a90c6b124adefbfb5aa487bb3ff46621e3dfa82b77c33376ec09c1e"
    sha256 arm64_big_sur:  "2638ab248cf822d3e4e1b3e8e8576c751286f6e680cc0aa12c4b9c10aaa9e7db"
    sha256 ventura:        "ca5e7f3fc813eee13a71000be7c8d4472e5aa86cd8b1895a1f73cd080f47ff4a"
    sha256 monterey:       "76649c856cc3a741771f2def2fd42edbc64379f883238022a90923f1e02ce729"
    sha256 big_sur:        "efe33ce142627641f8ed82446abf72a7faa6f1dd686532ebcc7f9564a6cd0088"
    sha256 x86_64_linux:   "e53496032d8a11529da83391677a65a8135cd98be8818f2fe5941e0abf7b0298"
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
