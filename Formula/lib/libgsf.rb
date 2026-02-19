class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://gitlab.gnome.org/GNOME/libgsf"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.55.tar.xz"
  sha256 "74d60abba15bd3ea5ad17da5b924d8e36f649a25c3dc77adbabd2a3628a02131"
  license "LGPL-2.1-only"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "a9cfe6cb82653598ac70d6c9e5a2dc57fa7aba7a98b00c5e569060249f34f4bc"
    sha256 arm64_sequoia: "b55c750532e3a3e6e267430e646b82eaf03d4159aeab007d864a27fc971a2fa2"
    sha256 arm64_sonoma:  "1792763d1149ee6277d7b63b5f90c07a908bc90502871eb79118cd611013df67"
    sha256 sonoma:        "9308632b66afba70ba6f921c6593ffb211198840ba7c0ad0e8750208c496bb46"
    sha256 arm64_linux:   "b5b939a5637e13461288b498171b4b123947d91e6a002f9aa42fa35c8b341113"
    sha256 x86_64_linux:  "2c5517b9203ac2e8af0c698a7c164adfdacf4f248daa174d7784bbd74d46a6d3"
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

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
