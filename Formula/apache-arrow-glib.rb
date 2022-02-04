class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-7.0.0/apache-arrow-7.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-7.0.0/apache-arrow-7.0.0.tar.gz"
  sha256 "e8f49b149a15ecef4e40fcfab1b87c113c6b1ee186005c169e5cdf95d31a99de"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "master"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "c36d4214bf5045ddee5fd97d6d35dedba06b7f6227d49a56812eca5bdc80680b"
    sha256 cellar: :any, arm64_big_sur:  "9a0e51f4210f7d7e82191ed8e64764e5013f0c006cfe26326f3ab395c1298f75"
    sha256 cellar: :any, monterey:       "5b28f7595d12be0038c8aea1fbaf0078f098ee4c6cd67b928bf45236cf4578b1"
    sha256 cellar: :any, big_sur:        "9fa1aac1e9c41a6094f82a8f310a43a4aefc2e2ab46796e16f20fec74249c587"
    sha256 cellar: :any, catalina:       "76752c7a7c539af572f53122acb57091998d7029cb08da6d6b2afbee6cbefa75"
    sha256               x86_64_linux:   "a0fb026fe3657b45632d1b0dabc53105bef8ae0972ae346cbdc848e4ec3927cc"
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
