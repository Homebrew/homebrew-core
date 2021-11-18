class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-6.0.1/apache-arrow-6.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-6.0.1/apache-arrow-6.0.1.tar.gz"
  sha256 "3786b3d2df954d078b3e68f98d2e5aecbaa3fa2accf075d7a3a13c187b9c5294"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "master"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "99a92493445d77edbb219f48f21af705a59755cfae423d8e6f3591c307b53509"
    sha256 cellar: :any, monterey:      "aff34c03891097f715c90009775c4c1338c458f53a44d18cdbd6b708b19ca8ac"
    sha256 cellar: :any, big_sur:       "89d2ba16e8ad4c4ba1d868e2b6d004b0afeea7e16a7c5c60484ae63b81c32f83"
    sha256 cellar: :any, catalina:      "a3df595a8b242eb13aef17a3ebb049c4cdcabfc09f8ffcec351d9fd2eb21c35f"
    sha256               x86_64_linux:  "84ab9aff2b0583b5a97538c7f8cbeefdf2b3132fc7b2b9504b9c953d915a6cd5"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "glib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

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
