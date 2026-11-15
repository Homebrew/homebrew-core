class Magics < Formula
  desc "ECMWF's meteorological plotting software"
  homepage "https://confluence.ecmwf.int/display/MAGP/Magics"
  url "https://confluence.ecmwf.int/download/attachments/3473464/Magics-4.17.1-Source.tar.gz"
  sha256 "a0119c54c812b34a7b190ebf39c546bf523ede6c985e85ff3d41074b11f35598"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url "https://confluence.ecmwf.int/display/MAGP/Releases"
    regex(/href=.*?magics[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "d9737c2e7d04839c1996eac86958d1a9bd39e3649a2f197cf913b77df0f1ef99"
    sha256 arm64_tahoe:       "cd5a2ccfa9e68d8293eca06d86e51d3841b44803f9da2914090009292e86610b"
    sha256 arm64_sequoia:     "c9b9a446d0d896390ebe374c377405855062445f3e1e63f58b8c03b52a1d499a"
    sha256 arm64_linux:       "871f81372e1de4ff6832d65178016db2fb57e5e5d1e7fbc2c7a6031ce72b2dcd"
    sha256 x86_64_linux:      "1505704aac2628905cbe29bcf44bce60ccb48d5a2c76087cfb66a585cc8cb7cf"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "eccodes"
  depends_on "glib"
  depends_on "netcdf"
  depends_on "pango"
  depends_on "proj"
  depends_on "qtbase"

  uses_from_macos "expat"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  deny_network_access!

  def install
    # Use --define-prefix to avoid saving Cellar paths in CMake config
    args = %w[
      -DENABLE_METVIEW=ON
      -DENABLE_TESTS=OFF
      -DPKG_CONFIG_ARGN=--define-prefix
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <magics_api.h>

      int main(void) {
        mag_open();
        mag_setc("output_format", "ps");
        mag_setc("output_name", "testc");
        mag_coast();
        mag_close();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/magics", "-L#{lib}", "-lMagPlus"
    system "./test"
    assert_path_exists testpath/"testc.ps"
  end
end
