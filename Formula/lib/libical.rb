class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.20/libical-3.0.20.tar.gz"
  sha256 "e73de92f5a6ce84c1b00306446b290a2b08cdf0a80988eca0a2c9d5c3510b4c2"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f9456c87474eaba72b8161d536585beead8a8be4de54b053b8876e1e5ee8c455"
    sha256 cellar: :any,                 arm64_sonoma:  "78b1a1c587516767bd8d12e977fac2e5df784c46b93c61a9a3b503475aa1592e"
    sha256 cellar: :any,                 arm64_ventura: "989541e8c1084836db8846d7fee606fa7c62c1d4e2087af88cdcd0b76911862b"
    sha256 cellar: :any,                 sonoma:        "6c42ef3607c1a8d19f558b65bc237a9f9bf8a1a224b0f9ea92e1a25baa493b58"
    sha256 cellar: :any,                 ventura:       "15a4f6945fd75f1bef1338746aca9445c9ad57899c6ceb3a23ae63b12592a20b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37201920b3eb04236602e79071bd3300397f251eb55751840567e4be26756d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e37f1ea7e90528d641fdb663673c6b29d9aac026f1ae932c4ea2c510a4152fa"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "icu4c@77"

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
