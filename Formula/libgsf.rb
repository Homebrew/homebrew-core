class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://developer.gnome.org/gsf/"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.42.tar.xz"
  sha256 "29fffb87b278b3fb1b8ae9138c3b4529c1fce664f1f94297c146a8563df80dc2"

  bottle do
    sha256 "991c1058133dd8551cf35408dac2d17d6dbc5ef0fd9a10cca9b2c80d8600f372" => :high_sierra
    sha256 "192a8330ea0791eb95de79815207c40ab54b60a40fa287f376e286c9d4043661" => :sierra
    sha256 "e9af6f98bb9a0cfe498bcc72897b04eae6da11b3163caee9111e0a5b8cfcda36" => :el_capitan
  end

  head do
    url "https://github.com/GNOME/libgsf.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gdk-pixbuf" => :optional

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system bin/"gsf", "--help"
    (testpath/"test.c").write <<~EOS
      #include <gsf/gsf-utils.h>
      int main()
      {
          void
          gsf_init (void);
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/libgsf-1",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
