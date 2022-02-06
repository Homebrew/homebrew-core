class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.14/libical-3.0.14.tar.gz"
  sha256 "4284b780356f1dc6a01f16083e7b836e63d3815e27ed0eaaad684712357ccc8f"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cdafb3e229c246ea5e340d313375f4d89102a265d1a4053e0b037b4ddcf32f4f"
    sha256 cellar: :any,                 arm64_big_sur:  "994d26307e071d46943fe9ee53927ab7b930c3cd6e6691788177aa4215f97c23"
    sha256 cellar: :any,                 monterey:       "fc197a1dd6a88e2772c921a9193e8792252d80e626bf655d0c0969ae29e2fc59"
    sha256 cellar: :any,                 big_sur:        "b8681965365ca7cc2c7d0991b7ffc560180fc9ad74530114123fb25ac451882c"
    sha256 cellar: :any,                 catalina:       "7219b20efc82b1a0bb714b590f362b2619e7b0e83ddc2806f1d4bc8e52381a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2421e0fc97384a4005dcdd36753cacda8bd5e388c56eecd8c6ef27caf2bdd543"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "icu4c"

  uses_from_macos "libxml2"

  def install
    system "cmake", ".", "-DBDB_LIBRARY=BDB_LIBRARY-NOTFOUND",
                         "-DENABLE_GTK_DOC=OFF",
                         "-DSHARED_ONLY=ON",
                         "-DCMAKE_INSTALL_RPATH=#{rpath}",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define LIBICAL_GLIB_UNSTABLE_API 1
      #include <libical-glib/libical-glib.h>
      int main(int argc, char *argv[]) {
        ICalParser *parser = i_cal_parser_new();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lical-glib",
                   "-I#{Formula["glib"].opt_include}/glib-2.0",
                   "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test"
  end
end
