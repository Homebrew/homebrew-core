class Libinfinity < Formula
  desc "GObject-based C implementation of the Infinote protocol"
  homepage "https://gobby.github.io"
  url "http://releases.0x539.de/libinfinity/libinfinity-0.6.8.tar.gz"
  sha256 "0c4e7e0e5cb6ad5df4dbe19568de37b100a13e61475cf9d4e0f2a68fcdd2d45b"

  bottle do
    sha256 "1faad7e989ee0b318a6bc083d6dabc09b1bff20f29e85fb2eeaf0e204db77ed2" => :high_sierra
    sha256 "a57e350ab3149f0992f1ae56953eb951dea73601c0837d8268679395f247f8ec" => :sierra
    sha256 "b4d21db6a91949753057955b38fd47b8d289a2e5961ba6fc5e1fdc06c6f0d7a1" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "gnutls"
  depends_on "gsasl"

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
