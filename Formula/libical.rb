class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.16/libical-3.0.16.tar.gz"
  sha256 "b44705dd71ca4538c86fb16248483ab4b48978524fb1da5097bd76aa2e0f0c33"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9f4df4f8eb6603ca56d187d1cf728e87b43dca690419fa2e813906846ff36b9a"
    sha256 cellar: :any,                 arm64_monterey: "591eb2b2865d474ef792519e96e5da74c2f8481b4c5aad671a79d3b940f88fd4"
    sha256 cellar: :any,                 arm64_big_sur:  "fa58234dfd4543c3b3c4aadb6ca3419875330a276674a5af853adca6fe28393d"
    sha256 cellar: :any,                 ventura:        "faa365367394d2e2126ad3b8dc435fa0c993b66ea4caf7021fc6318cb4ce9f5b"
    sha256 cellar: :any,                 monterey:       "612436b983588dc3b03460ca8111afa4d909731aadd102907465ecf90d434ae0"
    sha256 cellar: :any,                 big_sur:        "0ac780f843bcf715ae93298eb93255202af31312a106fa1a1c5ef2a17c69f67b"
    sha256 cellar: :any,                 catalina:       "10e2448891b5aae10239d5b729af312d42de53b717a4ff3d96a5a7148ced10d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44c1e71e20fbc14577b40ae7a3f1b3e7dbe91d3a96f43ee309fd881e5337e367"
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
