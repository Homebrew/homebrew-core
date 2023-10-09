class Fwupd < Formula
  include Language::Python::Virtualenv

  desc "Firmware update daemon"
  homepage "https://github.com/fwupd/fwupd"
  url "https://github.com/fwupd/fwupd/releases/download/1.9.6/fwupd-1.9.6.tar.xz"
  sha256 "c5fe96634bf6c5af7641cd08a48c6348aadd32d5f09ff8491e633f3c3a6bc0a1"
  license "LGPL-2.1-or-later"
  head "https://github.com/fwupd/fwupd.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "5ad2f54cdbebb45fb44b80a800b76cb2b9136370ea65bc2a9b3127ebe828b13a"
    sha256 arm64_ventura:  "4c81f3d703ffc1b3b2bd63de39e6ccabd22b253a82aeb1fdd4d0c076a91a0b7e"
    sha256 arm64_monterey: "60d77dd8320b184553bd163552f551b5cdcf412fcfb379e6d6dd1e87153b6783"
    sha256 sonoma:         "ddd377bf6021f6774ef928fc6f93707c01bbfc0cf7c7e8ee113326850ca8f443"
    sha256 ventura:        "c75d8b78526c48390b570983c2d9b99e911111c997ceee50e590482822ec7b25"
    sha256 monterey:       "72b01211bcf407f4ace3d074ffd26bf0e3d462bc86d07863f12966de04e7c82e"
    sha256 x86_64_linux:   "e2230c6119520c39cca2c6edf13d6913c86c04ab3b4aae8c6b43f30b7cb7ad92"
  end

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-markupsafe" => :build
  depends_on "python@3.11" => :build
  depends_on "vala" => :build
  depends_on "gcab"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libcbor"
  depends_on "libgusb"
  depends_on "libjcat"
  depends_on "libxmlb"
  depends_on "protobuf-c"
  uses_from_macos "curl"
  uses_from_macos "sqlite"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  def python3
    "python3.11"
  end

  def install
    venv_root = buildpath/"venv"
    venv = virtualenv_create(venv_root, python3)
    venv.pip_install resources

    system "meson", "setup", "build",
                    "-Dbuild=standalone", # this is used as PolicyKit is not available on macOS
                    "-Dlibarchive=enabled", # fail if missing
                    "-Dpython=#{venv_root}/bin/python",
                    "-Dsupported_build=enabled",
                    "-Dplugin_flashrom=disabled",
                    "-Dplugin_gpio=disabled",
                    "-Dplugin_modem_manager=disabled",
                    "-Dplugin_msr=disabled",
                    "-Dplugin_tpm=disabled",
                    "-Dplugin_uefi_capsule=disabled",
                    "-Dplugin_uefi_pk=disabled",
                    # these two are needed for https://github.com/fwupd/fwupd/pull/6147
                    "-Dplugin_logitech_scribe=disabled",
                    "-Dplugin_logitech_tap=disabled",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # check apps like gnome-firmware can link
    (testpath/"test.c").write <<~EOS
      #include <fwupd.h>
      int main(int argc, char *argv[]) {
        FwupdClient *client = fwupd_client_new();
        g_assert_nonnull(client);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/fwupd-1
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lfwupd
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    # this is a lame test, but fwupdtool requires root access to do anything much interesting
    system "#{bin}/fwupdtool", "-h"
  end
end
