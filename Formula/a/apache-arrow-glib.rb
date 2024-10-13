class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-17.0.0/apache-arrow-17.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-17.0.0/apache-arrow-17.0.0.tar.gz"
  sha256 "9d280d8042e7cf526f8c28d170d93bfab65e50f94569f6a790982a878d8d898d"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "3cb010cb2a7cabc7ecf9060e1e0e66ab16d0bde29882b35c4261d4c8e4906794"
    sha256 cellar: :any, arm64_sonoma:   "44c06cbf8331c2b4612cabb063d04cfb341b56ad6c314886078adde52a5584c9"
    sha256 cellar: :any, arm64_ventura:  "f5797649d689eeda12627778b78c599b88e1c06f70637909ad5584db06351b7d"
    sha256 cellar: :any, arm64_monterey: "2ea3b0551e83f9b9e51f4fe97b245076d33863302c7cd70992a5a632e74f166d"
    sha256 cellar: :any, sonoma:         "a12d690ad808f9e3b470f4106f0c801568114564da7d14e08ef1d6c53fd9e2e2"
    sha256 cellar: :any, ventura:        "3e5562b7125e439340ce6c659ceda2582c3ade6ba5482637c60bd76b2f5574a4"
    sha256 cellar: :any, monterey:       "e4682184e705f1a254db97a63f760e2c0c8e14ee675c6f741f27b21d7f039c99"
    sha256               x86_64_linux:   "b5f0317ddd0781971b7abb26cdb237c2b425aada56bb7e3d2db4c0ec27e9b95e"
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
