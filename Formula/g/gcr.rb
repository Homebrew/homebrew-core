class Gcr < Formula
  desc "Library for bits of crypto UI and parsing"
  homepage "https://gitlab.gnome.org/GNOME/gcr"
  url "https://download.gnome.org/sources/gcr/4.4/gcr-4.4.1.tar.xz"
  sha256 "c4442c15d4330f17a1f5194df08c576877af68412ab2521446a93bd5e24c931b"
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
    sha256 arm64_golden_gate: "affdc242b6126b78c1b93d6107a4c2db71cc56c752ebf1fec8e9ab1a15d92aca"
    sha256 arm64_tahoe:       "711044b2de080a0874953f5b56d4cdac52023f5950dc6a517b79a524bb57876a"
    sha256 arm64_sequoia:     "8534179cbe65fb82115c099bc9ecd9a28ca4b476c17e0bb8cf94fc2d2bd84542"
    sha256 arm64_linux:       "3677e3c9220ba82c8532d0a57a147c46cd42ca1f21d264f7ed232f34d5755b11"
    sha256 x86_64_linux:      "fd12034c41ee44e76d4aab103313e63ba87f7d4e2cbfa538924df3728cd591c8"
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
