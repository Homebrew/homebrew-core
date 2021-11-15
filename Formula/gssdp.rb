class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/1.4/gssdp-1.4.0.1.tar.xz"
  sha256 "8676849d57fb822b8728856dbadebf3867f89ee47a0ec47a20045d011f431582"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "af3cfdeebe33dc2235b183b4b5db2dc89cc1746e5f9d1f66497540008ac139ec"
    sha256 cellar: :any, big_sur:       "f1b7f55cf138a7b567c9b19f6a053a96e91c9cf1fe74d15d6d45918e80d0ae7b"
    sha256 cellar: :any, catalina:      "0247e477790f650d86a7e093747b7a3d48fd59420e85cdac0700c24eea101fe0"
    sha256 cellar: :any, mojave:        "037dfafa30476082ad6d7c31cdedcda2a45f899a1b2ddba1ab7291f17c59f405"
    sha256               x86_64_linux:  "ef5baab8ee1c70435c33b983055869689384280ce341b6d27ffc67f8a64662d8"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
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
