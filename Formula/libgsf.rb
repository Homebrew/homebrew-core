class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://developer.gnome.org/gsf/"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.42.tar.xz"
  sha256 "29fffb87b278b3fb1b8ae9138c3b4529c1fce664f1f94297c146a8563df80dc2"

  bottle do
    sha256 "76b39b701b7d152744861ccc137107277589f65d7b731a24fff6404fa146fe48" => :high_sierra
    sha256 "c7540109a9d799969ccf04f4cebd1c55c20e2f0b93313b3d0d0502ea6be28ade" => :sierra
    sha256 "434efb359e8f149061659e9173826fa9e2ade089ad4cff88da0efce0070c813e" => :el_capitan
    sha256 "f0f105ef96ede22df075cc256385c9df5f9c61832a9eb60a86aa1087696b4c85" => :yosemite
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
