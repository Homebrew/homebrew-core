class Magics < Formula
  desc "ECMWF's meteorological plotting software"
  homepage "https://confluence.ecmwf.int/display/MAGP/Magics"
  url "https://confluence.ecmwf.int/download/attachments/3473464/Magics-4.16.0-Source.tar.gz"
  sha256 "b5cf365e10e43abbb2e0b14db8e8d8db90486031f6c0de24b0b01c17a0197cf5"
  license "Apache-2.0"

  livecheck do
    url "https://confluence.ecmwf.int/display/MAGP/Releases"
    regex(/href=.*?magics[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "ab5ef87626865bb0a5fafaf059f679f592fe99903168234f027bed02f882f51d"
    sha256 arm64_tahoe:       "9bff7bb5e7f9044d264a741b35a68fb1603952d16fbe8dd261806b791de224f1"
    sha256 arm64_sequoia:     "6756f4ade57c494461f56f3f57c670fb62d051e657178efe68af6f8e83cf0fde"
    sha256 arm64_linux:       "e8e83e91d1add49811f85d9c4a56741b0e57a418196446a95a1f0f26922f36b9"
    sha256 x86_64_linux:      "1db8be1f9ec3bf6a13048856c12f8bf6c4950537f391e4f6506dae9ddfd08b2f"
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
