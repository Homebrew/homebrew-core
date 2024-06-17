class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-16.1.0/apache-arrow-16.1.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-16.1.0/apache-arrow-16.1.0.tar.gz"
  sha256 "c9e60c7e87e59383d21b20dc874b17153729ee153264af6d21654b7dff2c60d7"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "957a364810f5c39609ae74767818ebafd8ffc2fe7b4b7b69d7479ed29ed6689e"
    sha256 cellar: :any, arm64_ventura:  "4b818bdb3c546fb709c92b6a5891fcf5208bb54f70936abb5a623759f9f0af4d"
    sha256 cellar: :any, arm64_monterey: "8c2ff20d280bfd97f30fdfd3d9fe99829ef94abf2c742f4526387dd1ef856d6f"
    sha256 cellar: :any, sonoma:         "3fd8a5a37d01ac53854f7e7234e8cea82dc98d94a3acef4e62343e6bf9a531db"
    sha256 cellar: :any, ventura:        "ff39f9dd5c2cc5752d6653f286935790c7513c469c58fad998bd009f1a7eafda"
    sha256 cellar: :any, monterey:       "005f7dfde36fc6d7a6ec7fe98461f9d32ca7fced24746d89ea1c75744a5984ac"
    sha256               x86_64_linux:   "c3596a82e03ac7e0862429faf3b686adad14fdf04c03e4d85f70c1b849e16661"
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
