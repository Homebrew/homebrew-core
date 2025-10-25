class Metview < Formula
  desc "Meteorological workstation software"
  homepage "https://metview.readthedocs.io/en/latest/"
  url "https://confluence.ecmwf.int/download/attachments/51731119/MetviewBundle-2025.10.1-Source.tar.gz"
  version "5.26.1"
  sha256 "2dc2be8146cb7bcbae3d7cd833f521e426d8bb743452202f0e36e857b38f6d85"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/METV/The+Metview+Source+Bundle"
    regex(%r{>\s*Metview\s*<.+?<td[^>]*?>\s*v?(\d+(?:\.\d+)+)\s*</td}im)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "d3a67d82260e52fb5492b4aacda4a269e610b0f815727626cdc0e11afa57c0d5"
    sha256 arm64_sequoia: "58d68231a3f452c1d91fbefbfc393858e906fab3c6438007fa343607132ac262"
    sha256 arm64_sonoma:  "7a9e6ed00db35e8b844d2700f694f6a7f8898a070343960a5b35997431b64862"
    sha256 sonoma:        "7fff956e0fd60ca305b99743ad1cb1f0c7bb337b5dfe3bd56cc57780f12b0d40"
    sha256 x86_64_linux:  "6f16c80df89c3e659162ac7ed028d3a2617895642acdd8a444fe785169b7cc37"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
  depends_on "netcdf-cxx"
  depends_on "openssl@3"
  depends_on "pango"
  depends_on "proj"
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "qtsvg"

  uses_from_macos "bison" => :build
  uses_from_macos "flex"  => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "expat"

  on_macos do
    depends_on "gcc"
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
    assert_path_exists testpath/"test.1.png"
  end
end
