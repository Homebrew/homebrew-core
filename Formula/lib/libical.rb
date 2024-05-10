class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.18/libical-3.0.18.tar.gz"
  sha256 "72b7dc1a5937533aee5a2baefc990983b66b141dd80d43b51f80aced4aae219c"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cbfdd5df533fe16d1e4cb8ae08e3506b56144e46a5a7bed20baa66fbfb172722"
    sha256 cellar: :any,                 arm64_ventura:  "54e10eeed68faed65e321d173a38b00583cbe916260ff53470b6c22e1d912366"
    sha256 cellar: :any,                 arm64_monterey: "bcf9371441b25ef1f0d6c54f655ce0c2711bb0d0063d37d8f3ad891cb5072b07"
    sha256 cellar: :any,                 sonoma:         "4d7b3012fc7364658ba8ea249b78e5e328a3f1a7dd2a9e5aca4efc704ddd1847"
    sha256 cellar: :any,                 ventura:        "58216622ec0d87ec6abcfe1bc672824d1607d66ad1f9b651195c7ae816bfe161"
    sha256 cellar: :any,                 monterey:       "2ba4c21b0ca62f8ba830d7335190df0e44ae9caeb245ad6de1857ccf64cb61c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93aff19dd7bfe76ffe8c9416e135db82e598c68e8923f31763c8fa15d430aa08"
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
