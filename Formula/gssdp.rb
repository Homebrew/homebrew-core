class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/1.2/gssdp-1.2.3.tar.xz"
  sha256 "a263dcb6730e3b3dc4bbbff80cf3fab4cd364021981d419db6dd5a8e148aa7e8"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e3bc6dfa4ed41b0629533dbbe8fc4d9132a4349e05aacf0ea8099bf868fd6951"
    sha256 cellar: :any, big_sur:       "f5b00ceef2fed5c0140a8983fc8fed49cd220d1ad0cf1718125a81a047e370c3"
    sha256 cellar: :any, catalina:      "9cda1333eede84e831da2553e50989bd5721460b0ab046c95414305c11e29adc"
    sha256 cellar: :any, mojave:        "de497cd6d3225d91ce49ef33b23928bb8af0d5cdebea072e06c8cf022a7a5dda"
    sha256 cellar: :any, high_sierra:   "c6c767ccfe0b7220929d94ce06d3c4d5f8f172ab03e2a65900d96e1f2b151595"
    sha256               x86_64_linux:  "18d28afa706c370dc59f1868cf1141f26918107bfb4aeae8cfa619001ac8b3be"
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
