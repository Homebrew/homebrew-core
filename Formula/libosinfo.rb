class Libosinfo < Formula
  desc "The Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/libosinfo-1.8.0.tar.xz"
  sha256 "49ff32be0d209f6c99480e28b94340ac3dd0158322ae4303adfbdfe973a108a5"
  license "GPL-2.0"

  bottle do
    sha256 "4630d49afe37d27ddb3402e9630ba7366c22e461b2da61d394ee883d376d4568" => :catalina
    sha256 "c124ac38aae888e7195aedd04817cf9e6477cfe1acec2c8a34a797ce34f2bfaf" => :mojave
    sha256 "b230dea9754e476fb87710555bf53e7564b87b51295f7ec92a88a7326a411639" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"
  depends_on "libxml2"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Denable-gtk-doc=false", ".."
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <osinfo/osinfo.h>

      int main(int argc, char *argv[]) {
        OsinfoPlatformList *list = osinfo_platformlist_new();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libosinfo-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -losinfo-1.0
      -lglib-2.0
      -lgobject-2.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
