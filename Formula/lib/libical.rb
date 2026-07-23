class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v4.0.3/libical-4.0.3.tar.gz"
  sha256 "86f29029d0ec9fa30c9001de16c0859a3816ae154ff5b097392b014e21a3d254"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "02e90b1fa91e1cf46d5e58e8fef59149bc62f24e12f38dd87128f964c8ae2ba6"
    sha256 cellar: :any, arm64_sequoia: "3eac51a82310a33d8b91b0018ced3df845b0f4b5ed7b93337a03e347084862d4"
    sha256 cellar: :any, arm64_sonoma:  "3d2546321333cb02bd8d9403f97fc14634e641f20a0b863c524dddfcde6c2811"
    sha256 cellar: :any, sonoma:        "400c6e3d47e9054b789ab098d4edfbe62c8b30581f7bfa4bf7fcf4cac6058f03"
    sha256 cellar: :any, arm64_linux:   "a519b93d30b693aee45f8ba6917b661f684b6985ecbd8a6642d1b9827895fc13"
    sha256 cellar: :any, x86_64_linux:  "ad3462b6b0ecadcf79391fc00bbb187998e322d6f74328585e44124d87c4a0e1"
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
                   "-I#{formula_opt_include("glib")}/glib-2.0",
                   "-I#{formula_opt_lib("glib")}/glib-2.0/include"
    system "./test"
  end
end
