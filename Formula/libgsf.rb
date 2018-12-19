class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://developer.gnome.org/gsf/"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.45.tar.xz"
  sha256 "5cbc2c0f1dc44d202fa0c6e3a51e9f17b0c2deb8711ba650432bfde3180b69fa"

  bottle do
    sha256 "ee188e921ec4d409d508350e7095f9eec3477c18ba8f32ebb08a50cf8cf84770" => :mojave
    sha256 "1ee24dd553a23a8c561b538dae961bb8556f4fc2f4c62adb941d601340beb4b9" => :high_sierra
    sha256 "694c1e3bdac79f19203dc6d9f9eb6f19721119d34908d7b5ad50725f443d6e3f" => :sierra
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
