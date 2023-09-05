class Gmime < Formula
  desc "MIME mail utilities"
  homepage "https://github.com/jstedfast/gmime"
  url "https://github.com/jstedfast/gmime/releases/download/3.2.14/gmime-3.2.14.tar.xz"
  sha256 "a5eb3dd675f72e545c8bc1cd12107e4aad2eaec1905eb7b4013cdb1fbe5e2317"
  license "LGPL-2.1-or-later"

  bottle do
    sha256                               arm64_ventura:  "044c983cc0bcac0afd5c682d7e3335725fff4d516cd63f313d179475e82c4f69"
    sha256                               arm64_monterey: "f3180a7361908b78af5f77b13ac0272aba1fa2fcfc3c2828a0e54e66d4d74c89"
    sha256                               arm64_big_sur:  "e787c7dee3b75cebf54f1d4853beb65b13eb03aab28bfdfd2b807262eac842cb"
    sha256                               ventura:        "b6f4a0108ef544fd29c78042d1f0f5f9201ba053e0273a67b95ba853db8e7ae3"
    sha256                               monterey:       "fb2bf3bc747fe38b596f3613a70878b6931ce1fede9388ba78a35a7b9b4f9542"
    sha256                               big_sur:        "267d9303bc727c3a12bdad0ca161aed3cba93feb2696524f2a59f0079609d31c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d0c31d8ef46929e72b0e7450a19beafef6ff50e7e07896d2182a495bb0a8320"
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
