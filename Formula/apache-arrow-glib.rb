class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-2.0.0/apache-arrow-2.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-2.0.0/apache-arrow-2.0.0.tar.gz"
  sha256 "be0342cc847bb340d86aeaef43596a0b6c1dbf1ede9c789a503d939e01c71fbe"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "915a5ef975e06d79c541d24e5106ecdb8740b8365ad5cf270dfc11b75d16e529" => :big_sur
    sha256 "b51bf431c664c55d949ae469e69575aa170b6adf878a0692497c5b9556943a4e" => :catalina
    sha256 "3e04b577e546fdcf67ab353f52091044658efc633ad69a2c08f748db5c483718" => :mojave
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "../c_glib"
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
