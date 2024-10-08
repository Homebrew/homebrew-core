class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.18/libical-3.0.18.tar.gz"
  sha256 "72b7dc1a5937533aee5a2baefc990983b66b141dd80d43b51f80aced4aae219c"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d20beee387e3132a08bae4aa4c1986645c2a62ea8c7d5d9b4314c605c71b9ca7"
    sha256 cellar: :any,                 arm64_sonoma:  "c156bffb3feda317d56f25be8e4c766b91d47fa967bb38f500fe0328de76d84e"
    sha256 cellar: :any,                 arm64_ventura: "f32c8a8e616eb893a4e4d1e24af8a689481b5a99c450da50363f8fd2621e17f1"
    sha256 cellar: :any,                 sonoma:        "7c5d002710b29007a98342189383f09f7e415ce36ee392f60048c95d7373cb69"
    sha256 cellar: :any,                 ventura:       "3e8c3993a3f12bc769fa2777fa3db14d7f50d3ebdb3976c00353ae39c09d8919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61b322b00a6f8848f5c0ef0a12f91d5789188ea712846071a950d4562159b564"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "icu4c@75"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "berkeley-db@5"
  end

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
