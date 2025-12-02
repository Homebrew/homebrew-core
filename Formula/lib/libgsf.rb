class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://gitlab.gnome.org/GNOME/libgsf"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.53.tar.xz"
  sha256 "0eb59a86e0c50f97ac9cfe4d8cc1969f623f2ae8c5296f2414571ff0a9e8bcba"
  license "LGPL-2.1-only"
  revision 2

  bottle do
    sha256 arm64_tahoe:   "a2495ccfd26a1806327e17ac2664e775d16e32bc2ebcc5d5d5a0e7960ab0824a"
    sha256 arm64_sequoia: "1f1b24a80654b5a1fc0258ab9ecd8075c93a7e32ccb891f0926f6ee0c776ae02"
    sha256 arm64_sonoma:  "88c2032568c9187ccccb96523c5501d601f371bf9012437907eb9ee19528ce29"
    sha256 sonoma:        "30e687653e82a9c80777fb7728b10f341dd6fd6ef7d99b7310b2e49d8393d742"
    sha256 arm64_linux:   "4fb0e28455b2a455b4d03539ee2920c012f404bb557486f8ba868e8d4eb70312"
    sha256 x86_64_linux:  "327455f5ca5ab1a869a9603f1ee32bacde9f27c92768ca37a065bbe5ee9b58ad"
  end

  head do
    url "https://github.com/GNOME/libgsf.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "glib"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"gsf", "--help"
    (testpath/"test.c").write <<~C
      #include <gsf/gsf-utils.h>
      int main()
      {
          void
          gsf_init (void);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test",
           "-I#{include}/libgsf-1",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test"
  end
end
