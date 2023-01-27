class Gmime < Formula
  desc "MIME mail utilities"
  homepage "https://github.com/jstedfast/gmime"
  url "https://github.com/jstedfast/gmime/releases/download/3.2.13/gmime-3.2.13.tar.xz"
  sha256 "2e10a54d4821daf8b16c019ad5d567e0fb8e766f8ffe5fec3d4c6a37373d6406"
  license "LGPL-2.1-or-later"

  bottle do
    sha256                               arm64_ventura:  "2a4e60e2f6765cee1aa9b62cfefbf60ca2f8a9ed17515eaee2ffa498bae89e8f"
    sha256                               arm64_monterey: "18050619c00d2e6b994b91472ed9567716f0d77ee64b200626ff6ab066e87aaa"
    sha256                               arm64_big_sur:  "0c12167da5badd3447325e0770666c1e7f5e5e8945613e4c54c4e3e5ef1915fa"
    sha256                               ventura:        "42a150333087225e353b0d4574bbd51b9eb0619acef18d5ca47895fc229bad4b"
    sha256                               monterey:       "ea53d26dfed5e8441375732cc9c626436480ad9cfae885b9883b00e3b09b197b"
    sha256                               big_sur:        "3714b2907a93c2495efb79c0cf870bdab5683c64c17696836b19e5b34108b852"
    sha256                               catalina:       "877f2024cc0d97bc94f559ad992f87bdf6fdc23f9a1acc7b5bb13f0711b734c3"
    sha256                               mojave:         "7a0bda5bca906bc62e3ab24fc39752e2858fce861ba759040fc864928ab18d96"
    sha256                               high_sierra:    "0bb48841eae316695037bcd793673d518d0f2be20968a115a81c92824fb77ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07bffed5c3be937ee007bd878ff92561ed7f17f841d5062eccc7a8900e416b42"
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
