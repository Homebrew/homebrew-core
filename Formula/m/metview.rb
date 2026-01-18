class Metview < Formula
  desc "Meteorological workstation software"
  homepage "https://metview.readthedocs.io/en/latest/"
  url "https://confluence.ecmwf.int/download/attachments/51731119/MetviewBundle-2026.1.0-Source.tar.gz"
  version "5.26.2"
  sha256 "2bf48203c63c09303938323ac99b3a40d78d51d258b44e7d0d42ab2935d791a2"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/METV/The+Metview+Source+Bundle"
    regex(%r{>\s*Metview\s*<.+?<td[^>]*?>\s*v?(\d+(?:\.\d+)+)\s*</td}im)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "97972f980eda2a1a3ed9c38faa18a4a3c13a350ae3e8c6404e32ed8d2cf049b1"
    sha256 arm64_sequoia: "5415a49fe7e1d8a17e0b0359ee34fc8cac1ec72ea442cf58f28dca234504ed0a"
    sha256 arm64_sonoma:  "df1ad37284c828312c9d8aef790a7ed2ca61ea9f2d137a4ca6042601694d4e5e"
    sha256 sonoma:        "0b85a8444c3b7f3efbd3db4c367abfc44f9cb86073040bff8c4f1cd640ba1513"
    sha256 arm64_linux:   "c6a9ddea39dee0dffc6c1df4febe181acb0c1e2899519bac0dcc00e684e0e995"
    sha256 x86_64_linux:  "533048cc0caf2525e564cc1193a416cdc205fcf47e0b172084aec740071883c8"
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
