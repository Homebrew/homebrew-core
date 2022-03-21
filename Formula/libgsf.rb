class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://gitlab.gnome.org/GNOME/libgsf"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.49.tar.xz"
  sha256 "e9ebe36688f010c9e6e40c8903f3732948deb8aca032578d07d0751bd82cf857"
  license "LGPL-2.1-only"

  bottle do
    sha256 arm64_monterey: "0f68d9e85cc01cf4ddde476019363836b5e1cb3d913c259c35297868dd2c53a2"
    sha256 arm64_big_sur:  "ac636909e945c9f23f3c572fee770d10da012fb98b2ce8264efac8746c5b94b2"
    sha256 monterey:       "6ecd62d5c077353d2870f6d6edb965662cdbc8ba6bbafa665078a2ed4386adaa"
    sha256 big_sur:        "91f9dbc9298d4912a5253e58745be39eac1ae5bf52c9c8bfaffed501386f391b"
    sha256 catalina:       "506784ec0575361b52ab434531167a7fe664ec6fe6fd1bfd6b038a8404b8226b"
    sha256 x86_64_linux:   "896243a1484bdefe58bfe9e686ed17686897d584efd28acd8e6d73e7c28fa726"
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
