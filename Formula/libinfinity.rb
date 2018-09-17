class Libinfinity < Formula
  desc "GObject-based C implementation of the Infinote protocol"
  homepage "https://gobby.github.io"
  url "http://releases.0x539.de/libinfinity/libinfinity-0.6.8.tar.gz"
  sha256 "0c4e7e0e5cb6ad5df4dbe19568de37b100a13e61475cf9d4e0f2a68fcdd2d45b"
  revision 1

  bottle do
    sha256 "a95d07fc7f92c09d4867cbe74adca17e3895a29538bc747f742226ae7d9dbc10" => :mojave
    sha256 "5a82262c8519af2c73c3ee69c9632031cc6e7cc6bc52c2eef5defe74025b7a24" => :high_sierra
    sha256 "d9791b732d6a5c1bbba29941cfc8e0847c92bacebc43cdf9aef26799e8bada8f" => :sierra
    sha256 "ad024ec7122272de003ebfee98ffa2c0518d40061dbf7631627e720ef27ad4e9" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "gtk+3"

  # MacPorts patch to fix pam include. This is still applicable to 0.6.4.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f8e3d2e4/libinfinity/patch-infinoted-infinoted-pam.c.diff"
    sha256 "d5924d6ee90c3aa756e52b97e32345dc1d77afdb5e4e0de8eac2a343d95ade00"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-gtk3", "--with-inftextgtk", "--with-infgtk"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libinfinity/common/inf-init.h>

      int main(int argc, char *argv[]) {
        GError *error = NULL;
        gboolean status = inf_init(&error);
        return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gnutls = Formula["gnutls"]
    gsasl = Formula["gsasl"]
    libtasn1 = Formula["libtasn1"]
    nettle = Formula["nettle"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gnutls.opt_include}
      -I#{gsasl.opt_include}
      -I#{include}/libinfinity-0.6
      -I#{libtasn1.opt_include}
      -I#{nettle.opt_include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gnutls.opt_lib}
      -L#{gsasl.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lgnutls
      -lgobject-2.0
      -lgsasl
      -lgthread-2.0
      -linfinity-0.6
      -lintl
      -lxml2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
