class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://developer.gnome.org/libpeas/stable/"
  url "https://download.gnome.org/sources/libpeas/1.22/libpeas-1.22.0.tar.xz"
  sha256 "5b2fc0f53962b25bca131a5ec0139e6fef8e254481b6e777975f7a1d2702a962"
  revision 2

  bottle do
    sha256 "f33cfee795a9688c79eea11fb7288f00c4544ee942d7accb54ed700922fcd89e" => :high_sierra
    sha256 "39b4be69280c5c8b4bfce3f2d4253d06345d9a50910891324eb9624256b8b65a" => :sierra
    sha256 "e564ba0cc81e732fdd1e5632d5628ab1ac9c9a45d094b17e22d01dde345f3946" => :el_capitan
  end

  option "with-python@2", "Build with support for python2 plugins"

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "python"
  depends_on "python@2" => :optional

  if build.with? "python@2"
    depends_on "pygobject3" => "with-python@2"
  else
    depends_on "pygobject3"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-gtk
      --enable-python3
    ]

    xy = Language::Python.major_minor_version "python3"
    py3_lib = Formula["python"].opt_frameworks/"Python.framework/Versions/#{xy}/lib"
    ENV.append "LDFLAGS", "-L#{py3_lib}"

    if build.with? "python@2"
      py2_lib = Formula["python@2"].opt_frameworks/"Python.framework/Versions/2.7/lib"
      ENV.append "LDFLAGS", "-L#{py2_lib}"
      args << "--enable-python2"
    else
      args << "--disable-python2"
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
