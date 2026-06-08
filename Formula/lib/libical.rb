class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v4.0.2/libical-4.0.2.tar.gz"
  sha256 "39a979bb5474af3c4601c83dc71512c1121dee56722b3d8d8668ed75bd78ccdd"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "490cda94eaf5dd9e111810bbc3d34127fd9b9413481c1be45569910ba23f3119"
    sha256 cellar: :any, arm64_sequoia: "4f4ff236c73afc3f7ba9b9bd15bfdb1b35bfd2463c47d15fa51764175d2908d2"
    sha256 cellar: :any, arm64_sonoma:  "71dbdac9bff695204de40c3c799b9f13fbbd326237c2ace58fd4525dbdff7482"
    sha256 cellar: :any, sonoma:        "7eed9ae61faa257ec108d51cdd25ba40c654e0f55606070d1fbbebb88786daa6"
    sha256 cellar: :any, arm64_linux:   "3b5c62fc9f7965f05dd6e247fd9f38325cd09c4e3a08c8732ec588be42124fb6"
    sha256 cellar: :any, x86_64_linux:  "3f260ef5d685c41a33a328bebf21a45f91bfe2fc01c806d1ab4cec33d482985e"
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
