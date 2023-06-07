class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.16/libical-3.0.16.tar.gz"
  sha256 "b44705dd71ca4538c86fb16248483ab4b48978524fb1da5097bd76aa2e0f0c33"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "62bf349d6122a16c0101ccc42c835b7590e031d09b286342c67d427704769a07"
    sha256 cellar: :any,                 arm64_monterey: "2bf8f1668559a62c50b56d72792625f110e7f7c31ebe5fc027eb9786aeaae3f9"
    sha256 cellar: :any,                 arm64_big_sur:  "fd113bee7500ff6302eff57a6e83d7fe48e1fbe70485e866a2455ef4340bdbf1"
    sha256 cellar: :any,                 ventura:        "fd92c690a39bbfacfa98aa28f09745d2c6461ec077a6b38ed92d9d89f56de534"
    sha256 cellar: :any,                 monterey:       "f1a12aa0732995cf4b6fbb19aa0a283b67b6caffd505676f7d5597580848856d"
    sha256 cellar: :any,                 big_sur:        "0634c82ca970a36b44cfe565da1b905c618a6955113677e931c678749ee20f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e42d2b1727be76105550a883bd11892e80303300163b8bc914cfa313c1941600"
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
