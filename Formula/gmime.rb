class Gmime < Formula
  desc "MIME mail utilities"
  homepage "https://github.com/jstedfast/gmime"
  url "https://github.com/jstedfast/gmime/releases/download/3.2.13/gmime-3.2.13.tar.xz"
  sha256 "2e10a54d4821daf8b16c019ad5d567e0fb8e766f8ffe5fec3d4c6a37373d6406"
  license "LGPL-2.1-or-later"

  bottle do
    sha256                               arm64_ventura:  "35dc9d92ec33ec3d84b118fe2bbc0ec55d639fc0c26ca1f288db2041b8cc66f5"
    sha256                               arm64_monterey: "f27bc95fba280b579a93fda869ecb738e84593cf02e4fb689f668ef3b8668b40"
    sha256                               arm64_big_sur:  "616305d3cdeb697de0139126e9f85138bed8beab38b79f6aa982b7b846be23cb"
    sha256                               ventura:        "b3543eda3347b28808d6881d6b175d25192484563ffc5877a4ba5f82a26046da"
    sha256                               monterey:       "9a2055499bf7a18b01bfa67d3637ca0a376a0353a52a984a1864ff0890280a27"
    sha256                               big_sur:        "26ba4775f26d0549b57240711b9d446dacd825b52a11b0e1ff1c77410f2fe36c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "343edd8abff04d84cba81782ee2c447da2be52b2187581d25e989fe107c65b26"
  end

  head do
    url "https://github.com/jstedfast/gmime.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gpgme"

  def install
    args = %w[
      --enable-largefile
      --disable-vala
      --disable-glibtest
      --enable-crypto
      --enable-introspection
    ]

    system "./autogen.sh" if build.head?

    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <gmime/gmime.h>
      int main (int argc, char **argv)
      {
        g_mime_init();
        if (gmime_major_version>=3) {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    pcre = Formula["pcre"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gmime-3.0
      -I#{pcre.opt_include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgmime-3.0
      -lgobject-2.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "-o", "test", "test.c", *flags
    system "./test"
  end
end
