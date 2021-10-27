class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-5.0.0/apache-arrow-5.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-5.0.0/apache-arrow-5.0.0.tar.gz"
  sha256 "c3b4313eca594c20f761a836719721aaf0760001af896baec3ab64420ff9910a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git", branch: "master"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "14dacc92aee6feb94ced99c5091eb8a379d3e7061ed4318254337d708c79ac8d"
    sha256 cellar: :any, big_sur:       "aceda9f6f1f97953c0ea0ee4d13cdc3811b1d95bb936d82644b1bb4110f13c40"
    sha256 cellar: :any, catalina:      "2e272fca881e40573cbad30ef3e2886974dae72baf4a99aedc2773d39d4f8177"
    sha256 cellar: :any, mojave:        "102fb67cc64ddd5205300783133b6007757848a66137963b0f70716f79094ed4"
    sha256               x86_64_linux:  "45918aa14c92f89f499034b4ff1a91526c4ab0c47c7ff003f9c92e6238ed12f1"
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
