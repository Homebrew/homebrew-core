class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/1.4/gssdp-1.4.0.1.tar.xz"
  sha256 "8676849d57fb822b8728856dbadebf3867f89ee47a0ec47a20045d011f431582"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f8d473345a33036b882bf4b5721940b17cdfbacc59c6f6c7bc21b354cebafc77"
    sha256 cellar: :any, big_sur:       "7e3f746570d185163477dbc29d5d1b52bd9fb1655223d9428817e998c62c57df"
    sha256 cellar: :any, catalina:      "7ca8d4f29d9d29cb3359116f07062a81410900cf0296d2d1f9e9d8d7a3930cb6"
    sha256 cellar: :any, mojave:        "fc63d29a1b04887aa478eb7da62593e15ec23efb853533f8ab2e2c11db89a533"
    sha256               x86_64_linux:  "375c1f636abd720cef920fb12e71fd4628f95eaee83fc8fbcbaf9ae86e1dd68a"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dsniffer=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libgssdp/gssdp.h>

      int main(int argc, char *argv[]) {
        GType type = gssdp_client_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gssdp-1.2
      -D_REENTRANT
      -L#{lib}
      -lgssdp-1.2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
