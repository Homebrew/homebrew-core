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
    sha256 arm64_tahoe:   "d97dd29284c76815166bc14455cb3cb8e632c0e0baa506715dce9a648cb1dd9e"
    sha256 arm64_sequoia: "3a44777454a3ed970b418a318828f1617aee0b863b3e88d5b00cd85f23cd0a4d"
    sha256 arm64_sonoma:  "20b9f86a68b2df6407de5262d460c300b44fa19e622c9f8a153e1e2b2b6bc339"
    sha256 sonoma:        "903a82a21a78ad2fbf7189fefd109e9363a7b6689ec55f6460814964b7d4f399"
    sha256 arm64_linux:   "eccc585bf2056c1bf6483375a1519520fde37c534ebd1678082ecec54ae7eaa2"
    sha256 x86_64_linux:  "e8ee8092b3c51fd47df8d62ed2929caca696eaca01e9c4696ef41ab26ac9d271"
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

  def install
    args = %w[
      -DENABLE_METVIEW=ON
      -DENABLE_TESTS=OFF
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
