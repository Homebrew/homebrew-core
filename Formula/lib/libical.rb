class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.20/libical-3.0.20.tar.gz"
  sha256 "e73de92f5a6ce84c1b00306446b290a2b08cdf0a80988eca0a2c9d5c3510b4c2"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e1775a193b70aa777149fe615df614690b76c8dfae6218b3bde9b99d7ddeff0d"
    sha256 cellar: :any,                 arm64_sequoia: "fa2e31da1a9ae0c91f0e0c40781c1944ef4d0264d800e522cb64005201d51eb8"
    sha256 cellar: :any,                 arm64_sonoma:  "7724be091019953ea44192d748b4779734e38e3c75dc8c37816ae30e59b43fe2"
    sha256 cellar: :any,                 sonoma:        "2810b40ad0cdbfccc9c9fe85e464e2b02b51df136f0e3b6873fa15a09f5a4596"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2d4abf841da30c205d8bed921b326366b71f1ede6f73dfd3261f6d1e09d0bc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b3213a9eee392cad9cface173a0b533f0a137a6585ed22501c8eea8e9b9d959"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "icu4c@78"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "berkeley-db@5"
  end

  def install
    args = %W[
      -DBDB_LIBRARY=BDB_LIBRARY-NOTFOUND
      -DENABLE_GTK_DOC=OFF
      -DSHARED_ONLY=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #define LIBICAL_GLIB_UNSTABLE_API 1
      #include <libical-glib/libical-glib.h>
      int main(int argc, char *argv[]) {
        ICalParser *parser = i_cal_parser_new();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lical-glib",
                   "-I#{Formula["glib"].opt_include}/glib-2.0",
                   "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test"
  end
end
