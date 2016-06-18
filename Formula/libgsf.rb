class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://developer.gnome.org/gsf/"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.38.tar.xz"
  sha256 "1e8c85ac9dd7828b6213685079d8fc5fb6595c929dc4a23270f297c154782650"

  bottle do
    sha256 "f2f3f3c3f1c5f88c9e23be7194cebf06d71e9b5b72f4c73104b57de75f54a948" => :el_capitan
    sha256 "af2b868a09f6ed5325a2861a2dfb54b03c41e9bb5b51e9399b3f7b8b4ce554a1" => :yosemite
    sha256 "0922d62570dddfc6b9f5bbb11c59df5ff52fa3b450e215aaf57da82eb6f28a5d" => :mavericks
  end

  head do
    url "https://github.com/GNOME/libgsf.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gdk-pixbuf" => :optional
  depends_on "gettext"
  depends_on "glib"

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
    (testpath/"test.c").write <<-EOS.undent
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
