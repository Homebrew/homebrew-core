class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://developer.gnome.org/gsf/"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.47.tar.xz"
  sha256 "d188ebd3787b5375a8fd38ee6f761a2007de5e98fa0cf5623f271daa67ba774d"

  bottle do
    sha256 "82a2fce8b091d204302919c7541a0ad21a28a24fe8ad8a5d4ae7f50f3f190349" => :catalina
    sha256 "a051f21e80044277fafb60264c915cb79ce5f64059e9737f7a15795bc79ad3c8" => :mojave
    sha256 "c2cb9985014c2c727abe935f113ab827e5a7af1e4376c27261897381fc87a2ba" => :high_sierra
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

  uses_from_macos "libxml2"

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
