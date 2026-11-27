class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://gitlab.gnome.org/GNOME/libgsf"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.61.tar.xz"
  sha256 "59698b8fdf3db2dae03bb492826168dd9073ff762ccc11e980306aabe97087aa"
  license "LGPL-2.1-only"
  compatibility_version 1

  bottle do
    manifest_sha256 "e68c576f2e1e19f2ccbf5bfab920c8b21de40b7d9cf5ddc9fdd78125e62e7939"
    sha256 arm64_golden_gate: "bd7a9f597df56731ef5cf30da0056daf00bf28db02147bdf0edf7be435c586b4"
    sha256 arm64_tahoe:       "b51950a7ba586233cb5d8a39648db343adf549bcea8e4e14fc55407ea63391c8"
    sha256 arm64_sequoia:     "c5f8fafc3c614c14054d1efe32a590f7ab071ae1994a4bd5803603268fbdd842"
    sha256 arm64_linux:       "d7f42a64ee35729499053dd88aee6ab425d7934c9a64414934fdae10d794e71f"
    sha256 x86_64_linux:      "993d46554f6c3d2536ff12815e1ab4ac5db3343ed31f6aa034a95ea4bef49d5a"
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
