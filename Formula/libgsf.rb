class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://developer.gnome.org/gsf/"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.38.tar.xz"
  sha256 "1e8c85ac9dd7828b6213685079d8fc5fb6595c929dc4a23270f297c154782650"

  bottle do
    sha256 "801a86baeb2d228c65be1e6db5d8eb5e9aae0612386f22aa98351a9c24037a8b" => :el_capitan
    sha256 "c8bd6da0786ab72d2f01b117c4e94da38f6a761190737072261c8d6623b9a606" => :yosemite
    sha256 "9dd51b8178686d41b17bed63eb7920c787cb57eff13e08c180dc29be478a1e83" => :mavericks
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
