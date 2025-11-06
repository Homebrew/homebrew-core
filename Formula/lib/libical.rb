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
    sha256 cellar: :any,                 arm64_tahoe:   "9947b3e026805b69dd932ff37e8f5b038f33d55042783f01320805aa0eaf2525"
    sha256 cellar: :any,                 arm64_sequoia: "8a95d52f3fae76f4252b74adafd4e82a2512a0c78c4a1cbe9b83ea215143e513"
    sha256 cellar: :any,                 arm64_sonoma:  "5592f102e7a4da49d6de58655e2ea3b8998aaef51bf74c5f524a4694cc612f98"
    sha256 cellar: :any,                 sonoma:        "8cc7a1bc62d20db855e43f0c2c42cccb9cc17e2c14fe4bc2779ce40e410df32d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3662c9b1e5cf9c1f2824266ef71cebcc93dde2cef195477c1238f968353516f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5cc9dc2fa2fe2deca5871429fc5f2023a9ca677f23d9680804652514a03edb2"
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
