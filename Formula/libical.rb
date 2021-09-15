class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.10/libical-3.0.10.tar.gz"
  sha256 "f933b3e6cf9d56a35bb5625e8e4a9c3a50239a85aea05ed842932c1a1dc336b4"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "d21ba9fd766b87b6b30b220e2fcd5b26f93e7a5618f6e38790402ac6f105aaa8"
    sha256 cellar: :any,                 big_sur:       "9d900728f649ccb4c9e80df219089b8f608e9027f7cb313896115574acc8d93a"
    sha256 cellar: :any,                 catalina:      "a76e728e573b3d72e288009edc4e3f6d792a3ef7b91fca78e9a6b5d12ee6cd3b"
    sha256 cellar: :any,                 mojave:        "5c8fbf1cb846303940f183de67b538dc0c1139a3117d115db3aa3e02c25d0c28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cf5e25555b0770dd13c33a5c63c9799ca62292deac37c0ee2515946fe9c6d7d"
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
