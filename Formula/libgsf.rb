class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://developer.gnome.org/gsf/"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.44.tar.xz"
  sha256 "68bede10037164764992970b4cb57cd6add6986a846d04657af9d5fac774ffde"

  bottle do
    sha256 "93e371516b562160d21ce01177ce374e3cf230a06d79f879583d1d126af2606c" => :high_sierra
    sha256 "4d53f3f3c337161669faf4c8bece29a90a8a875171cbc1d76a331f0d231f44cf" => :sierra
    sha256 "cbed5a072ffd00e82f14a8d17e3a897357df53a92289eac230c84de8f17fc818" => :el_capitan
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
