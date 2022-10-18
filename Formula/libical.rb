class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.16/libical-3.0.16.tar.gz"
  sha256 "b44705dd71ca4538c86fb16248483ab4b48978524fb1da5097bd76aa2e0f0c33"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d28809fee3e91fea87fd3152b30d7aedc14e2a9b031515409fbc71c2ba9dad91"
    sha256 cellar: :any,                 arm64_big_sur:  "bda2d4f9dbf98272e4069df418f247c58e9e01896a5bfc9459e54005a05546de"
    sha256 cellar: :any,                 monterey:       "1bd5f06af617f73ae97d5b1c012fc4c6ddd52f8a627614135064867a0ea869b1"
    sha256 cellar: :any,                 big_sur:        "ca719d61e0e5bf8fcbc81b7f6eb52c031d2743cb3691faeb08f1e614a9e37cc8"
    sha256 cellar: :any,                 catalina:       "338c4055555d7d472e8d4b1f39259362876b3e175e08f4a3c0940694753161a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84dbc8a7d4e3933adc62bc4dc5e94faef8d415f5c3109bd2791c8894305d27d3"
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
