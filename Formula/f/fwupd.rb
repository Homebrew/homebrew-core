class Fwupd < Formula
  include Language::Python::Virtualenv

  desc "Firmware update daemon"
  homepage "https://github.com/fwupd/fwupd"
  url "https://github.com/fwupd/fwupd/releases/download/1.9.5/fwupd-1.9.5.tar.xz"
  sha256 "201ec20538044749c96dbff708e52f7d79038de787b90a2762e76793080aa37c"
  license "LGPL-2.1-or-later"
  head "https://github.com/fwupd/fwupd.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "e3cb97c25f8620bc5bb4cdf7f76fc0a198e56b80430d327f3683311698538ba6"
    sha256 arm64_monterey: "6ee0840adc9ce90d01761d32aadc616886eceb383bb005c73774c8bbe433526d"
    sha256 arm64_big_sur:  "2b2d7d2ec92d10caef46e5b499077a6ac644ac1b607c1aec7ffa1efc6297f093"
    sha256 ventura:        "104bf7001de23e552902ff4725b89ca0df66dc84fbce0eca6567956d2734d25b"
    sha256 monterey:       "14f5d36e91a8cac3ef1c2f788c5b7d021c5cd0c83b831f265db96216aec18cbc"
    sha256 big_sur:        "2fa9406c77045e9dc7cb256710a6de3f38371950eec3bed09ae07eebc9f7f28b"
    sha256 x86_64_linux:   "9b13b1d783c768df23fdd626138b5b1ae4a51053828487843989851fe73e7caa"
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
                    "-Dplugin_dell=disabled",
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
