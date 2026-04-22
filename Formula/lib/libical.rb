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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ac4a8191b1b659e8439da4765e3c7ac591d838f1deb3ceee74b9962e91faa513"
    sha256 cellar: :any,                 arm64_sequoia: "03a9412643774563a580ee5b96132fdeee39e6b73d24bed845a521b5451a56a8"
    sha256 cellar: :any,                 arm64_sonoma:  "7106190ead9d59a8679a29b4743e1876922b3765d1e575441c720f350ffa2fbb"
    sha256 cellar: :any,                 sonoma:        "49011b8b33ecb6de63946e79c23daab5e0c851d17f1cbd075706adae86539601"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a56a71650ae63ecbfd7a46034dfa5f3e4188f4079a0cef73c67c68c051892851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "276ee1adb53b80fbef7c71bc97bf5a59008d599d24e79d6ce57a9cffb8f6bb9b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "icu4c@78"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      -DCMAKE_DISABLE_FIND_PACKAGE_BerkeleyDB=ON
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
