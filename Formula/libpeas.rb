class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://developer.gnome.org/libpeas/stable/"
  url "https://download.gnome.org/sources/libpeas/1.22/libpeas-1.22.0.tar.xz"
  sha256 "5b2fc0f53962b25bca131a5ec0139e6fef8e254481b6e777975f7a1d2702a962"

  bottle do
    sha256 "2ea4bc3ecb98d714926827f205ec7a38023c99809e6c76112966c46ca029560e" => :high_sierra
    sha256 "761fe27f39245b4e7604d8dc49872a659432e788c179209b63b3a993f273071a" => :sierra
    sha256 "0f521913ca0eaf13b55aacb75e4b87a730be1f527215741ae2ba207caac523b2" => :el_capitan
  end

  option "with-python", "install support for running Python plugins"

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on :python => "with-python"
  depends_on :python3 => "with-python"
  depends_on "pygobject3" if build.with? "python"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-gtk
    ]

    # Unset PYTHONPATH as it creates more confusion that it tries to
    # remove when both v2 and v3 are installed
    ENV.delete("PYTHONPATH")

    if build.with? "python"
      # extra hoop to jump if both, Python 2 and 3 are installed in parallel
      py2_prefix = `python2-config --prefix`.chomp
      py2_lib = "#{py2_prefix}/lib"
      py3_prefix = `python3-config --prefix`.chomp
      py3_lib = "#{py3_prefix}/lib"
      ENV["LDFLAGS"] = "#{ENV["LDFLAGS"]} -L#{py2_lib} -L#{py3_lib}"
      # configure argument
      args << "--enable-python2"
      args << "--enable-python3"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libpeas/peas.h>

      int main(int argc, char *argv[]) {
        PeasObjectModule *mod = peas_object_module_new("test", "test", FALSE);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gobject_introspection = Formula["gobject-introspection"]
    libffi = Formula["libffi"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gobject_introspection.opt_include}/gobject-introspection-1.0
      -I#{include}/libpeas-1.0
      -I#{libffi.opt_lib}/libffi-3.0.13/include
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gobject_introspection.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lgirepository-1.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lintl
      -lpeas-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
