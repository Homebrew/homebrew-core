class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-10.0.0/apache-arrow-10.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-10.0.0/apache-arrow-10.0.0.tar.gz"
  sha256 "5b46fa4c54f53e5df0019fe0f9d421e93fc906b625ebe8e89eed010d561f1f12"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "master"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "326158e572e0f0ae23d52f0725513160d209de402a4a842d50941fa0df5ea702"
    sha256 cellar: :any, arm64_monterey: "cf39cc0a235798468ef7e5d9436fd11ff9a991766b0c27bc344b358b8dc58203"
    sha256 cellar: :any, arm64_big_sur:  "bbaf448491ad97e95ddc6dd45dea4ad554fd2617481ce77b5822b2bbed8102cc"
    sha256 cellar: :any, ventura:        "695abbbf7b7fc2ea807930747d46d142373ce41cf2e20eab02fd8f0f1c04848f"
    sha256 cellar: :any, monterey:       "36b6d7234cd3a57036e1980a2960776ac0b05dae2e83437ead887d6cffd4ae4f"
    sha256 cellar: :any, big_sur:        "5f030acaf8b9f14d49525b925cce2175536c3d0671ab036fc114cbedf79f5044"
    sha256 cellar: :any, catalina:       "0f3b50a0f84f202ee2da067ada80105489fe7f25b9f7377b569e51107a9ec750"
    sha256               x86_64_linux:   "56ccca099849cf54d9078ed11e3dedbf38857fb3590a72c935e7a1f30aedb347"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "glib"

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
