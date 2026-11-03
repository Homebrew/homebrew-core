class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://gitlab.gnome.org/GNOME/libgsf"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.60.tar.xz"
  sha256 "83e12c36a099a8a7019bf425e2c24af66eeb2ef5874251e694431a07d9805dae"
  license "LGPL-2.1-only"
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "9436bac8cb0841a8e346ae6bab292acf14cc0e133b424a6e7f0169c800c207cd"
    sha256 arm64_tahoe:       "4144eab57f7da47f0c5a9d1d455d27e11159e58b677f893ca0b623e1f7bd72ce"
    sha256 arm64_sequoia:     "6e152a26ea8bc565998431ce25754b70674b8583506ed3d8d2eee936cb28a43c"
    sha256 arm64_linux:       "3b8b3dd591f3978224e5f66dda92757d8827f907bbdedbda20eae8ec957089ed"
    sha256 x86_64_linux:      "b56a8d49f812ae6968b28627e2ef6d80384778a473ab28c7ddf77f88cb96b5ae"
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

  deny_network_access!

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
           "-I#{formula_opt_include("glib")}/glib-2.0",
           "-I#{formula_opt_lib("glib")}/glib-2.0/include"
    system "./test"
  end
end
