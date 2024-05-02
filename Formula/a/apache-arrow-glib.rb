class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-16.0.0/apache-arrow-16.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-16.0.0/apache-arrow-16.0.0.tar.gz"
  sha256 "9f4051ae9473c97991d9af801e2f94ae3455067719ca7f90b8137f9e9a700b8d"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "cace9de8228c855a5e9fe1ef5fe1ae353dc6f791854ae3fdd217aa293ddb6868"
    sha256 cellar: :any, arm64_ventura:  "cbae74218417e72ecad14832117b6888c4ec54200c71529c74533e678be0a505"
    sha256 cellar: :any, arm64_monterey: "3e6351128d81dc839281f985bfdfd147f0a7ce398f1ae289d8dcdf2b139b1a62"
    sha256 cellar: :any, sonoma:         "c0ebaa906e9ead64d5301ddd726a7e6dedc13e5734214735d29f18bfd11c9642"
    sha256 cellar: :any, ventura:        "1af78ad7a4a664f2bc1cb0bb2977ead4006cda6c19f8700bedb3391bcbe3c36a"
    sha256 cellar: :any, monterey:       "75ef106748e468ab3f8b412516eccf4e454cd07ba81cecd3acfee979dd5c79fd"
    sha256               x86_64_linux:   "bba98396529bd625f737b240a9f63c173b71533cf4b763a7563508b8528828d2"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "glib"

  fails_with gcc: "5"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(/^llvm(@\d+)?$/) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

    system "meson", "setup", "build", "c_glib", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~SOURCE
      #include <arrow-glib/arrow-glib.h>
      int main(void) {
        GArrowNullArray *array = garrow_null_array_new(10);
        g_object_unref(array);
        return 0;
      }
    SOURCE
    apache_arrow = Formula["apache-arrow"]
    glib = Formula["glib"]
    flags = %W[
      -I#{include}
      -I#{apache_arrow.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -L#{lib}
      -L#{apache_arrow.opt_lib}
      -L#{glib.opt_lib}
      -DNDEBUG
      -larrow-glib
      -larrow
      -lglib-2.0
      -lgobject-2.0
      -lgio-2.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
