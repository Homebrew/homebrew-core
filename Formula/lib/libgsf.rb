class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://gitlab.gnome.org/GNOME/libgsf"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.56.tar.xz"
  sha256 "9d21d30df1d12feaf03e181afd6067f65e3048ab69cb6ad174a3c5b72b92d297"
  license "LGPL-2.1-only"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "93bba7ab89f824f8f5254b51a359c552882657829eb61abc8c06d163ced310ac"
    sha256 arm64_sequoia: "6ae4e73e0dc930dfe01d2276853ad7270f3fb708610b68a879e8543e290a5819"
    sha256 arm64_sonoma:  "89e7f6755007e7f994fdaf3232b2ac49b4da158ddf70efd04abaddabb9aa3a9d"
    sha256 sonoma:        "a96ac3b911a2530e51bff3b5860b0aae49aa2b0fffc31285ae80919e41be55c3"
    sha256 arm64_linux:   "17e0396ea0417f85e39b927851ebe16cb36252bf4c594de26973bb898d600e10"
    sha256 x86_64_linux:  "e60809d6c79421276882cef126c23d64aa0cc7c84978b5e4f26aeaf995077eea"
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
