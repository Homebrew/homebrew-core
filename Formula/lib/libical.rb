class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v4.0.5/libical-4.0.5.tar.gz"
  sha256 "cc09a3ac41d60e6144e644bd3fcf97d47106d659c4a0b8965102581401e67c9c"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f1de09188a68e831bdd83655483216b53ef49c5335e4450b4fac95badf587796"
    sha256 cellar: :any, arm64_sequoia: "e29340ff7ce9cdb11c7f8f4f9c7a3e9a7412b8cdc8cdaea9e5b5faa5468cbdf4"
    sha256 cellar: :any, arm64_sonoma:  "62aa6a36d618e228f58564b31286960b34df4241661f8d7ebdd5ad1a99cebfd8"
    sha256 cellar: :any, sonoma:        "bd4a3ef9c7aca5b77697562c3499f9eb96da5ea4a49c302ad73085ebc6c1f804"
    sha256 cellar: :any, arm64_linux:   "77f9a63ebfe12a913f3ff7303e91161d8fa38fdf0f29073cec6dd96e160063e3"
    sha256 cellar: :any, x86_64_linux:  "3184327968b165956effba33099920b62ac22e68ccbaf29ffc259a8513ed24de"
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
