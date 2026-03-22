class Gcr < Formula
  desc "Library for bits of crypto UI and parsing"
  homepage "https://gitlab.gnome.org/GNOME/gcr"
  url "https://download.gnome.org/sources/gcr/4.4/gcr-4.4.0.1.tar.xz"
  sha256 "0c3c341e49f9f4f2532a4884509804190a0c2663e6120360bb298c5d174a8098"
  license all_of: [
    "LGPL-2.0-or-later",
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later", # gcr/gcr-ssh-agent-private.h
    "FSFULLRWD", # gck/{pkcs11x.h,pkcs11-trust-assertions.h}
  ]
  head "https://gitlab.gnome.org/GNOME/gcr.git", branch: "main"

  # gcr doesn't use GNOME's "even-numbered minor is stable" version scheme.
  # This regex matches any version that doesn't have a 90+ patch version, as
  # those are development releases.
  livecheck do
    url :stable
    regex(/gcr[._-]v?(\d+\.\d+\.(?:\d|[1-8]\d+)(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8a8b247f36bfc6a6343b6c4ea5de1b981d727f1a3b21c6b6185c6059baf806ff"
    sha256 arm64_sequoia: "c6dd2aaccd60bf27c4b3edca83a5ca7f087277840eccf91dffa5e4242e177ff1"
    sha256 arm64_sonoma:  "01875e5b7918fab6462935245afd7b2a9a5ea53da81c0d91c01a485f90aa00c8"
    sha256 arm64_ventura: "6d9fe7fd9e40c9a54abc080bb879e2ac30d9c9eba2e5623f4e0f61a1c95c276c"
    sha256 sonoma:        "004a771f4d6e7194c3a1650d26be0eca85adbc5b3df92876ccc74d5aefe9ea1b"
    sha256 ventura:       "0bc1474bbbf46af21896b8f8f5beedc58978b29fe106046481cd83c775d855dc"
    sha256 arm64_linux:   "57a4fea0430975807d6258ef58dda22db6eae2ac78b78d29876d9879dfc26977"
    sha256 x86_64_linux:  "7ea854a5ee93e6e1ca91d593571b5881f3b387dc3a4ac5bb2e44daf3b4e99111"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "gnupg" # for gpg executable
  depends_on "libgcrypt"
  depends_on "libsecret"
  depends_on "p11-kit"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "openssh" # for ssh-add and ssh-agent executables
    depends_on "systemd"
  end

  def install
    # Disabled GTK4 which is only for gcr-viewer-gtk4 tool
    system "meson", "setup", "build", "-Dgtk4=false", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource "der-certificate.crt" do
      url "https://gitlab.gnome.org/GNOME/gcr/-/raw/9019498dfef15efec4d12eee8becc55781062a30/gcr/fixtures/der-certificate.crt"
      sha256 "bc23f98a313cb92de3bbfc3a5a9f4461ac39494c4ae15a9e9df131e99b73019a"
    end
    testpath.install resource("der-certificate.crt")

    # https://gitlab.gnome.org/GNOME/gcr/-/blob/main/gcr/test-simple-certificate.c
    (testpath/"test.c").write <<~C
      #define GCR_API_SUBJECT_TO_CHANGE
      #include <gcr/gcr.h>
      #include <glib.h>

      int main(void) {
        GcrCertificate *cert;
        gconstpointer der;
        gpointer cert_data;
        gsize n_der, n_cert_data;

        if(!g_file_get_contents("der-certificate.crt", (gchar**)&cert_data, &n_cert_data, NULL))
          g_assert_not_reached();
        g_assert(cert_data);

        cert = gcr_simple_certificate_new(cert_data, n_cert_data);
        g_assert(GCR_IS_SIMPLE_CERTIFICATE(cert));

        der = gcr_certificate_get_der_data(cert, &n_der);
        g_assert(der);

        g_object_unref(cert);
        g_free(cert_data);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", *shell_output("pkgconf --cflags --libs gcr-4").chomp.split
    system "./test"
  end
end
