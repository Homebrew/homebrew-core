class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://developer.gnome.org/gsf/"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.46.tar.xz"
  sha256 "ea36959b1421fc8e72caa222f30ec3234d0ed95990e2bf28943a85f33eadad2d"
  revision 1

  bottle do
    sha256 "e4ce2838b44594d27c99dac9d17ad1f7d2752bd7cf33d514fce0a54e94542efe" => :mojave
    sha256 "8016acb38bd84a9d659a2c938b52e84128a242e54bf0c44236da9d875ae5de92" => :high_sierra
    sha256 "7534eb511218574e344d0c5ebc4ebdb110e6c476d6a2936277f9d584b88f765a" => :sierra
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
