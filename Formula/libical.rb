class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.14/libical-3.0.14.tar.gz"
  sha256 "4284b780356f1dc6a01f16083e7b836e63d3815e27ed0eaaad684712357ccc8f"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c27b4e5e0183e2a3c00df25be49016a32eabefe48df38495607cbe77cd1c4488"
    sha256 cellar: :any,                 arm64_big_sur:  "44b5d5d2e1004e59c723d21a30446bb642fab78cff44c48fb337e311d2c17509"
    sha256 cellar: :any,                 monterey:       "813ff353ca32c4f9c33d5141805fb244829872ed01333a75cabc1f9901ed2513"
    sha256 cellar: :any,                 big_sur:        "9db5384e8ca7edde36eeeddd905e53bf2019d3bf6fbb9b038954cf9a05d481d4"
    sha256 cellar: :any,                 catalina:       "77a6f2be525f7cd45016b36ebc34ffb018649864cf08ec7e52c98f17e158a65c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1143254b83d4f1fc88a23bad553c7ea335f094ac79fae35c3f93f16f53c225c2"
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
