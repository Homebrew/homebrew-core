class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.16/libical-3.0.16.tar.gz"
  sha256 "b44705dd71ca4538c86fb16248483ab4b48978524fb1da5097bd76aa2e0f0c33"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c050d9f87eed23b619587d6186991536b6cb1e5754f91b8c91087d3fa65adebb"
    sha256 cellar: :any,                 arm64_monterey: "8b49a65d54118f4ac09b1be213c9e69896f24942249b80d42af44765540ff834"
    sha256 cellar: :any,                 arm64_big_sur:  "f6794a31d01477036ac00bd085f8aade2f79c8714c11e353d7f1f33bd5190644"
    sha256 cellar: :any,                 ventura:        "411e3c4ae2630b643be69eea83b82c71f37e3432869fe0e7c37ee565b9039c93"
    sha256 cellar: :any,                 monterey:       "54fa8c5d6d8aabb91db257fcf042673d962dd0d2d45bdb2867e01217b2d77d22"
    sha256 cellar: :any,                 big_sur:        "59830d07e3216bb548df87dddda022a759c2e610e64e9d10b47dccce79211139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad4ff67df10fe9bf7967565c781de9516d2b88a18e331244d4ebaa1ced33d273"
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
