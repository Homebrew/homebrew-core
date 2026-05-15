class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v4.0.1/libical-4.0.1.tar.gz"
  sha256 "7c1d8b780ce305a8823e5824ec4d7eb05d85ae8f808836b495aa37b0c3d08337"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8fc15f68649b634b7cd954744ad925def9f47082a838d42a15f7160a204fc137"
    sha256 cellar: :any,                 arm64_sequoia: "56e4eecbabc9afcfebbc4affd313bd32affaf8a4fb192784df61a35b7dff1690"
    sha256 cellar: :any,                 arm64_sonoma:  "9acc0fba0e46d4d1db6bed7f7ef5b6d1ef88bbbbf87315e5a906a2c6dbf5f615"
    sha256 cellar: :any,                 sonoma:        "90326c037e0260342e8c20191c427dd912e7468043055af02e99fd776f9de9fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7dd534c93b55f8f2ac74bbe25787376d0d1f90fb46b1ce138d45d31ee397063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0285d397531579d556b1a69ebfddbc98e2c894da8ca2b046829cb5a731027b33"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
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
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLIBICAL_GLIB_BUILD_DOCS=OFF
      -DLIBICAL_JAVA_BINDINGS=OFF
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
