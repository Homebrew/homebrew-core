class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://developer.gnome.org/gsf/"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.46.tar.xz"
  sha256 "ea36959b1421fc8e72caa222f30ec3234d0ed95990e2bf28943a85f33eadad2d"

  bottle do
    sha256 "25109b3e2ea58c821bf66afea7eb83396c863575261252cc1a209439e5e7a69a" => :mojave
    sha256 "0c51ceb879565696a729f0f04154d3c0cbbe5ef58b0b2fd4c225f589db4e7631" => :high_sierra
    sha256 "10aa1ebe555e6976645075b059e50ee408311c40030fe5750ba6f7be9a23e9ab" => :sierra
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
