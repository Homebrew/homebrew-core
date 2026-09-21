class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://gitlab.gnome.org/GNOME/libgsf"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.59.tar.xz"
  sha256 "0d03cb6fadfe735caa13498a024ccd8fdb6cab77df6d9d283a64410c96f2fa49"
  license "LGPL-2.1-only"
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "4f3da8ed2c2f63f2dc52da430261a2a17a2bf23cea79aa92789ef53e0f0277d9"
    sha256 arm64_tahoe:       "f3acb1ba06832683f4b464abcbacd6474eeab445b9a31eb8ec46183103c9d6b6"
    sha256 arm64_sequoia:     "d25ad9dfb121fde82634a30c19dfde2c03e479dd26c2a12fbde8a5e3575a93f6"
    sha256 arm64_linux:       "09d7b66a05a8a9b9d35590cbebfbf30648c221609c86fd73c6e3e52edc51052e"
    sha256 x86_64_linux:      "bbfef7f8bec27fb05aff5d02e03836f8d09742dfff36d4d9aea0d05d1118c9cd"
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
           "-I#{formula_opt_include("glib")}/glib-2.0",
           "-I#{formula_opt_lib("glib")}/glib-2.0/include"
    system "./test"
  end
end
