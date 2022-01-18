class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.13/libical-3.0.13.tar.gz"
  sha256 "02543b08897f3b75c76c360a335900ccfb027d2f5120176c777340e67e763ad4"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "012aef3fc5b6cfe0401c9cb5f2002e2df9b91315cf3c51a3e8292ea87042c9f2"
    sha256 cellar: :any,                 arm64_big_sur:  "22caf6a06a1b690ece4e5390dbfab1da5b05298f4e632bac4b959e3ffc82e09e"
    sha256 cellar: :any,                 monterey:       "d9f18d5d7e206f1a0980682d5a7db06c3db2e6ce025c6b8219a9681130be9f63"
    sha256 cellar: :any,                 big_sur:        "b858d7dea00189fe61e10052952dc2724e06f31248d689519356a31357bee057"
    sha256 cellar: :any,                 catalina:       "2c98d4d35acc4785bb7f9a945b35c43d8b56b0c30c12978bf56d1a8c6723f07e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8d36f41565cc1847689d3619006f4e2e0a272c9a514e776465b2c3ba1af7066"
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
